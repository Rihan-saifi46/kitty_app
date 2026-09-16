import '../../../../core/mock/mock_engine_config.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../domain/entities/passbook_entry_entity.dart';
import '../../domain/repositories/i_passbook_repository.dart';
import '../dtos/passbook_dto.dart';
import '../mappers/passbook_mapper.dart';

/// Mock implementation of [IPassbookRepository].
class MockPassbookRepository implements IPassbookRepository {
  MockPassbookRepository({MockEngineConfig? engineConfig})
      : _engineConfig = engineConfig ?? MockEngineConfig.instance;

  final MockEngineConfig _engineConfig;

  @override
  Future<List<PassbookEntryEntity>> getPassbookEntries({
    String? membershipId,
  }) async {
    await _engineConfig.simulate();

    final List<dynamic> rawList = MockFixtures.dashboardActiveSuvarnaJson[
        'data']['dashboard']['passbook'] as List<dynamic>;

    return rawList
        .map((dynamic json) => PassbookMapper.toEntity(
            PassbookEntryDto.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}
