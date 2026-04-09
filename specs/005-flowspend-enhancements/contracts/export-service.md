# Contract: Export Service

**Version**: 1.0.0
**Date**: 2026-04-08

## Overview

The Export Service generates CSV and PDF exports of transaction data with Arabic RTL support and filtering capabilities.

---

## Service Interface

### ExportService

```dart
/// Service for generating transaction exports
class ExportService {
  /// Generate CSV file for transactions
  ///
  /// Returns path to generated file
  Future<String> generateCsv({
    required List<Transaction> transactions,
    required String monthKey,  // Format: "YYYY-MM"
    required Map<String, Category> categoryMap,
    required Map<int, Wallet> walletMap,
  });

  /// Generate PDF report for transactions
  ///
  /// Returns path to generated file
  Future<String> generatePdf({
    required List<Transaction> transactions,
    required String monthKey,
    required Map<String, Category> categoryMap,
    required Map<int, Wallet> walletMap,
    required ExportSummary summary,
  });

  /// Share a generated file using system share sheet
  Future<void> shareFile(String filePath);
}
```

### Data Types

```dart
/// Configuration for export
class ExportConfig {
  final String monthKey;              // "YYYY-MM"
  final ExportFormat format;          // csv or pdf
  final Set<String>? categoryFilter;  // null = all categories
  final Set<int>? walletFilter;       // null = all wallets
  final String? typeFilter;           // 'income' | 'expense' | null (all)

  const ExportConfig({
    required this.monthKey,
    required this.format,
    this.categoryFilter,
    this.walletFilter,
    this.typeFilter,
  });
}

enum ExportFormat { csv, pdf }

/// Pre-calculated summary for PDF header
class ExportSummary {
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final int transactionCount;
  final String? topCategory;      // Category with highest spending
  final double topCategoryAmount;

  const ExportSummary({...});
}
```

---

## CSV Format Contract

### File Structure

```
UTF-8 BOM + Header Row + Data Rows + Summary Row
```

### Header Row (Arabic)

```csv
التاريخ,الوصف,الفئة,المحفظة,النوع,المبلغ
```

### Data Row Format

```csv
2026-04-15,ماكدونالدز,طعام ومشروبات,كاش,مصروف,150.00
```

### Summary Row

```csv
,,,الإجمالي,دخل:,5000.00
,,,,,مصروف:,3500.00
,,,,,صافي:,1500.00
```

### File Naming

```
FlowSpend_2026-04_transactions.csv
```

### Encoding

- UTF-8 with BOM (`\uFEFF`) at start for Excel compatibility
- Line endings: CRLF (Windows-compatible)

---

## PDF Format Contract

### Page Layout

- **Size**: A4 portrait
- **Direction**: RTL (right-to-left)
- **Font**: Cairo (Arabic-supporting)
- **Margins**: 40pt all sides

### Structure

```
┌─────────────────────────────────────┐
│  FlowSpend                          │  ← Header
│  تقرير شهري — أبريل 2026            │
├─────────────────────────────────────┤
│  ┌──────────────────────────────┐   │
│  │ الدخل: 5,000 جنيه            │   │  ← Summary Box
│  │ المصروفات: 3,500 جنيه        │   │
│  │ الصافي: 1,500 جنيه           │   │
│  │ عدد المعاملات: 45            │   │
│  │ أعلى فئة: طعام ومشروبات      │   │
│  └──────────────────────────────┘   │
├─────────────────────────────────────┤
│  المعاملات                          │  ← Transaction Table
│  ┌─────┬─────┬─────┬─────┬─────┐   │
│  │التاريخ│الوصف│الفئة│المحفظة│المبلغ│   │
│  ├─────┼─────┼─────┼─────┼─────┤   │
│  │ ... │ ... │ ... │ ... │ ... │   │
│  └─────┴─────┴─────┴─────┴─────┘   │
├─────────────────────────────────────┤
│  توزيع المصروفات                    │  ← Category Breakdown
│  ┌─────────────────────────────┐    │
│  │ [Bar Chart or Pie Chart]    │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│  تم إنشاء هذا التقرير بواسطة FlowSpend │  ← Footer
│  2026-04-08                         │
└─────────────────────────────────────┘
```

### File Naming

```
FlowSpend_2026-04_report.pdf
```

### Color Scheme

- Income amounts: Green (#22C55E)
- Expense amounts: Red (#EF4444)
- Headers: Primary purple (#9D4EDD)
- Text: Dark gray (#1F2937)

---

## Provider Interface

```dart
/// Provider for export configuration state
final exportConfigProvider = StateProvider<ExportConfig>((ref) {
  final now = DateTime.now();
  return ExportConfig(
    monthKey: '${now.year}-${now.month.toString().padLeft(2, '0')}',
    format: ExportFormat.csv,
  );
});

/// Provider for filtered transactions based on config
final exportTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final config = ref.watch(exportConfigProvider);
  final repo = ref.watch(transactionRepoProvider);

  var transactions = await repo.getByMonth(config.monthKey);

  if (config.categoryFilter != null) {
    transactions = transactions.where((t) =>
      config.categoryFilter!.contains(t.category)
    ).toList();
  }

  if (config.walletFilter != null) {
    transactions = transactions.where((t) =>
      config.walletFilter!.contains(t.walletId)
    ).toList();
  }

  if (config.typeFilter != null) {
    transactions = transactions.where((t) =>
      t.type == config.typeFilter
    ).toList();
  }

  return transactions;
});

/// Provider for transaction count preview
final exportPreviewCountProvider = FutureProvider<int>((ref) async {
  final transactions = await ref.watch(exportTransactionsProvider.future);
  return transactions.length;
});
```

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| No transactions | Return error, disable export button in UI |
| File system error | Throw ExportException with message |
| PDF font loading fails | Fall back to default font, log warning |
| Share cancelled by user | Silent return (not an error) |
| Disk space insufficient | Throw ExportException |

---

## Performance Requirements

- CSV generation: < 5 seconds for 1000 transactions
- PDF generation: < 30 seconds for 1000 transactions
- File size: < 1MB for typical monthly export

---

## Accessibility

- PDF text is selectable (not image-based)
- Charts include data labels (not color-only)
- File names are descriptive and sortable by date
