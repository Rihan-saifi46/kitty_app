import '../entities/scheme_entity.dart';

/// Pure domain repository interface for gold savings scheme discovery.
abstract interface class ISchemeRepository {
  /// Retrieves list of active gold schemes.
  Future<List<SchemeEntity>> getActiveSchemes({int? durationFilter});

  /// Retrieves a specific scheme by unique ID.
  Future<SchemeEntity> getSchemeById(String id);
}
