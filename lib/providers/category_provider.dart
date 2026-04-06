import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/category_model.dart';
import '../data/repositories/category_repo.dart';
import '../data/services/isar_service.dart';

final categoryRepoProvider = Provider<CategoryRepo>((ref) {
  return CategoryRepo(ref.watch(isarProvider));
});

final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(categoryRepoProvider);
  return repo.getAll();
});

final expenseCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(categoryRepoProvider);
  return repo.getByType('expense');
});

final incomeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(categoryRepoProvider);
  return repo.getByType('income');
});
