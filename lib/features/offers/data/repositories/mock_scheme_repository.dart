import '../../../../core/errors/app_exception.dart';
import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/scheme_entity.dart';
import '../../domain/repositories/i_scheme_repository.dart';
import '../dtos/scheme_dto.dart';
import '../mappers/scheme_mapper.dart';

/// Mock implementation of [ISchemeRepository].
class MockSchemeRepository implements ISchemeRepository {
  MockSchemeRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig.instance;

  final MockEngineConfig _engineConfig;

  @override
  Future<List<SchemeEntity>> getActiveSchemes({int? durationFilter}) async {
    await _engineConfig.simulate();

    final List<dynamic> rawList =
        MockFixtures.activeSchemesJson['data']['schemes'] as List<dynamic>;

    final List<SchemeEntity> schemes = rawList
        .map((dynamic json) =>
            SchemeMapper.toEntity(SchemeDto.fromJson(json as Map<String, dynamic>)))
        .toList();

    if (durationFilter != null) {
      return schemes
          .where((SchemeEntity s) => s.durationMonths == durationFilter)
          .toList();
    }

    return schemes;
  }

  @override
  Future<SchemeEntity> getSchemeById(String id) async {
    await _engineConfig.simulate();

    final List<SchemeEntity> schemes = await getActiveSchemes();
    return schemes.firstWhere(
      (SchemeEntity s) => s.id == id,
      orElse: () => throw const NotFoundException(
        'Scheme not found with the requested ID.',
      ),
    );
  }
}
