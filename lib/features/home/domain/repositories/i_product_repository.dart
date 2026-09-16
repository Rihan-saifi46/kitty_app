import '../entities/product_entity.dart';

/// Repository contract for the jewelry products catalog.
abstract class IProductRepository {
  /// Fetches curated jewelry products optionally filtered by category.
  Future<List<ProductEntity>> getCuratedProducts({String? category});

  /// Fetches available product categories.
  Future<List<String>> getCategories();
}
