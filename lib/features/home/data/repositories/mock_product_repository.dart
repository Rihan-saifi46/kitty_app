import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../dtos/product_dto.dart';
import '../mappers/home_mapper.dart';

/// Mock implementation of [IProductRepository].
class MockProductRepository implements IProductRepository {
  MockProductRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig.instance;

  final MockEngineConfig _engineConfig;

  @override
  Future<List<ProductEntity>> getCuratedProducts({String? category}) async {
    await _engineConfig.simulate();

    final List<dynamic> rawList =
        MockFixtures.curatedProductsJson['data']['products'] as List<dynamic>;

    final List<ProductEntity> products = rawList
        .map((dynamic json) =>
            HomeMapper.toProductEntity(ProductDto.fromJson(json as Map<String, dynamic>)))
        .toList();

    if (category != null && category != 'All') {
      return products
          .where((ProductEntity p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    return products;
  }

  @override
  Future<List<String>> getCategories() async {
    await _engineConfig.simulate();

    final List<dynamic> rawList =
        MockFixtures.curatedProductsJson['data']['categories'] as List<dynamic>;

    return rawList.map((dynamic e) => e.toString()).toList();
  }
}
