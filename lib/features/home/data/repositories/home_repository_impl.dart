import '../../../../core/config/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/gold_rate_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/i_gold_rate_repository.dart';
import '../../domain/repositories/i_product_repository.dart';
import '../dtos/gold_rate_dto.dart';
import '../dtos/product_dto.dart';
import '../mappers/home_mapper.dart';

/// Remote implementation of [IGoldRateRepository] and [IProductRepository].
class HomeRepositoryImpl implements IGoldRateRepository, IProductRepository {
  HomeRepositoryImpl({required DioClient apiClient}) : _dio = apiClient;

  final DioClient _dio;

  @override
  Future<LiveGoldRateEntity> getLiveGoldRate() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.ratesGold);
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return HomeMapper.toGoldRateEntity(LiveGoldRateDto.fromJson(data));
  }

  @override
  Future<List<ProductEntity>> getCuratedProducts({String? category}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/products',
      queryParameters: category != null && category != 'All'
          ? <String, dynamic>{'category': category}
          : null,
    );

    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> list =
        data['products'] as List<dynamic>? ?? <dynamic>[];

    return list
        .map((dynamic json) => HomeMapper.toProductEntity(
            ProductDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/products/categories');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final List<dynamic> list =
        data['categories'] as List<dynamic>? ?? <dynamic>[];
    return list.map((dynamic e) => e.toString()).toList();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/v1/products/$id');
    final Map<String, dynamic> data =
        response.data?['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return HomeMapper.toProductEntity(
        ProductDto.fromJson(data['product'] as Map<String, dynamic>));
  }
}
