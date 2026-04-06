import 'package:isar/isar.dart';
import '../models/category_model.dart';

class CategoryRepo {
  final Isar isar;

  CategoryRepo(this.isar);

  Future<List<Category>> getAll() async {
    return isar.categorys.where().sortBySortOrder().findAll();
  }

  Future<List<Category>> getByType(String type) async {
    return isar.categorys
        .filter()
        .typeEqualTo(type)
        .sortBySortOrder()
        .findAll();
  }

  Future<Category?> getByName(String name) async {
    return isar.categorys.filter().nameEqualTo(name).findFirst();
  }

  Future<int> add(Category category) async {
    return isar.writeTxn(() async {
      return isar.categorys.put(category);
    });
  }

  Future<void> update(Category category) async {
    await isar.writeTxn(() async {
      await isar.categorys.put(category);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.categorys.delete(id);
    });
  }

  Future<void> reorder(List<Category> categories) async {
    await isar.writeTxn(() async {
      for (var i = 0; i < categories.length; i++) {
        categories[i].sortOrder = i;
        await isar.categorys.put(categories[i]);
      }
    });
  }

  Future<void> addSubcategory(int categoryId, String subcategory) async {
    await isar.writeTxn(() async {
      final cat = await isar.categorys.get(categoryId);
      if (cat != null && !cat.subcategories.contains(subcategory)) {
        cat.subcategories = [...cat.subcategories, subcategory];
        await isar.categorys.put(cat);
      }
    });
  }

  Future<void> removeSubcategory(int categoryId, String subcategory) async {
    await isar.writeTxn(() async {
      final cat = await isar.categorys.get(categoryId);
      if (cat != null) {
        cat.subcategories = cat.subcategories
            .where((s) => s != subcategory)
            .toList();
        await isar.categorys.put(cat);
      }
    });
  }
}
