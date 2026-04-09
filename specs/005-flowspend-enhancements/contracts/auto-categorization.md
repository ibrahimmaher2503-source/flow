# Contract: Auto-Categorization Service

**Version**: 1.0.0
**Date**: 2026-04-08

## Overview

The Auto-Categorization Service provides on-device transaction categorization based on keyword matching and user learning.

---

## Service Interface

### AutoCategorizationService

```dart
/// Auto-categorization service for transaction descriptions
class AutoCategorizationService {
  /// Suggest a category for the given transaction description
  ///
  /// Returns [CategorySuggestion] with category name and confidence,
  /// or null if no match found.
  Future<CategorySuggestion?> suggest(String description);

  /// Record a user correction (learning)
  ///
  /// Called when user changes the suggested category.
  /// Updates learned mappings in Isar.
  Future<void> recordCorrection({
    required String description,
    required String suggestedCategory,
    required String selectedCategory,
  });

  /// Initialize the service (load learned mappings)
  Future<void> initialize();
}
```

### Data Types

```dart
/// Result of category suggestion
class CategorySuggestion {
  final String categoryName;
  final double confidence;  // 0.0 to 1.0
  final bool isLearned;     // true if from user learning, false if built-in

  const CategorySuggestion({
    required this.categoryName,
    required this.confidence,
    required this.isLearned,
  });
}
```

---

## Behavior Contract

### suggest(description)

**Input**:
- `description`: Non-empty string (transaction note, merchant name, or SMS body)

**Output**:
- `CategorySuggestion` if match found with confidence ≥ 0.3
- `null` if no match or confidence too low

**Processing**:
1. Normalize input: `description.toLowerCase().trim()`
2. Check user-learned mappings first (Isar `CategoryMapping` collection)
3. If learned match found: return with `isLearned: true`, confidence based on hit count
4. Fall back to built-in keyword map
5. Count keyword matches per category
6. Return category with most matches if any

**Performance**:
- Must complete in < 500ms
- Learned mappings cached in memory after initialize()

### recordCorrection(...)

**Input**:
- `description`: Original transaction description
- `suggestedCategory`: What the service suggested (may be null if no suggestion)
- `selectedCategory`: What user actually selected

**Behavior**:
- Extract keywords from description (split by whitespace, filter common words)
- For each significant keyword:
  - If mapping exists: increment hitCount, update lastUsedAt
  - If no mapping: create new CategoryMapping

**Side Effects**:
- Writes to Isar `CategoryMapping` collection
- Updates in-memory cache

---

## Built-in Keywords

The service includes ~200+ pre-defined keywords covering Egyptian merchants and services:

| Category | Sample Keywords (Arabic + English) |
|----------|-----------------------------------|
| طعام ومشروبات | ماكدونالدز, mcdonald, كنتاكي, kfc, طلبات, talabat, starbucks |
| تسوق | امازون, amazon, جوميا, jumia, نون, noon, زارا, zara |
| مواصلات | اوبر, uber, كريم, careem, بنزين, petrol, مترو |
| اتصالات | فودافون, vodafone, اورانج, orange, وي, we |
| صحة | صيدلية, pharmacy, مستشفى, hospital, دكتور, doctor |
| تعليم | مدرسة, school, جامعة, university, كورس, course |
| ترفيه | netflix, سينما, cinema, spotify, العاب, games |
| فواتير | كهرباء, electricity, ماء, water, غاز, gas |
| تحويلات | instapay, فوري, fawry, بنك, bank, تحويل |
| سوبرماركت | كارفور, carrefour, سبينس, spinneys, هايبر, hyper |

---

## Provider Interface

```dart
/// Riverpod provider for auto-categorization
final autoCategorizeProvider = Provider<AutoCategorizationService>((ref) {
  final isar = ref.watch(isarProvider);
  return AutoCategorizationService(isar);
});

/// FutureProvider for suggestion (with debouncing in UI)
final categorySuggestionProvider = FutureProvider.family<CategorySuggestion?, String>(
  (ref, description) async {
    if (description.isEmpty) return null;
    final service = ref.watch(autoCategorizeProvider);
    return service.suggest(description);
  },
);
```

---

## UI Integration Points

### SMS Confirmation Screen

```dart
// Auto-fill category when SMS parsed
final suggestion = await ref.read(autoCategorizeProvider).suggest(smsBody);
if (suggestion != null) {
  setState(() {
    selectedCategory = suggestion.categoryName;
    showAutoLabel = true;  // Show "تصنيف تلقائي" indicator
  });
}
```

### Add Transaction Screen

```dart
// Debounced suggestion on description change
Timer? _debounce;

void onDescriptionChanged(String value) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    ref.invalidate(categorySuggestionProvider(value));
  });
}

// Show suggestion banner
final suggestion = ref.watch(categorySuggestionProvider(description));
if (suggestion != null) {
  SuggestionBanner(
    text: 'اقتراح: ${suggestion.categoryName}',
    onAccept: () => selectCategory(suggestion.categoryName),
    onDismiss: () => hideBanner(),
  );
}
```

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| Empty description | Return null immediately |
| Isar read error | Fall back to built-in keywords only |
| Isar write error (recordCorrection) | Log error, don't block user flow |
| Invalid category name | Skip recording, log warning |
