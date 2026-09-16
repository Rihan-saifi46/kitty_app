import '../../../../core/enums/app_enums.dart';
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
  bool _shouldThrow = false;
  List<SchemeEntity>? _customSchemes;

  // Scenario controls for testing
  void setShouldThrow(bool shouldThrow) => _shouldThrow = shouldThrow;
  void setCustomSchemes(List<SchemeEntity>? schemes) => _customSchemes = schemes;

  /// Prototype schemes matching offers.html design for dedicated preview
  static const List<SchemeEntity> prototypeSchemes = <SchemeEntity>[
    SchemeEntity(
      id: 'sch_12month_wedding',
      name: 'Wedding Collection',
      targetAmount: 360000,
      durationMonths: 12,
      monthlyInstallment: 30000,
      maxCapacity: 100,
      currentMembers: 64,
      status: SchemeStatusEnum.open,
      benefits: <String>[
        '1 Month Free: 11 Paid + 12th Month 100% Jeweler Sponsored Bonus',
        '25% Flat Discount on Jewellery Making Charges upon maturity',
        'Accumulate 24K 999 Hallmark Purity gold every month',
      ],
      isPopular: true,
      bannerImageUrl: 'assets/images/banner_clean_bonus.jpg',
    ),
    SchemeEntity(
      id: 'sch_12month_suvarna',
      name: 'Suvarna Varsha',
      targetAmount: 60000,
      durationMonths: 12,
      monthlyInstallment: 5000,
      maxCapacity: 100,
      currentMembers: 42,
      status: SchemeStatusEnum.open,
      benefits: <String>[
        'Classic Kitty: 1 Month Free Bonus on Month 12',
        'Guaranteed conversion at lowest daily market price',
        'Flexible redemption for 24K gold bullion or hallmarked ornaments',
      ],
      isPopular: false,
      bannerImageUrl: 'assets/images/banner_clean_bonus.jpg',
    ),
    SchemeEntity(
      id: 'sch_18month_bridal',
      name: 'Navratna Bridal Royal',
      targetAmount: 900000,
      durationMonths: 18,
      monthlyInstallment: 50000,
      maxCapacity: 50,
      currentMembers: 22,
      status: SchemeStatusEnum.open,
      benefits: <String>[
        '2 Months Free: 16 Paid + 2 Months Sponsored + ₹25,000 Diamond Gift',
        'Dedicated personal Swastik Jewellery Concierge service',
        'Priority access to new heritage, bridal polki & uncut diamond collections',
      ],
      isPopular: false,
      bannerImageUrl: 'assets/images/banner_clean_bridal.jpg',
    ),
    SchemeEntity(
      id: 'sch_6month_express',
      name: 'Dhanteras Labh Express',
      targetAmount: 60000,
      durationMonths: 6,
      monthlyInstallment: 10000,
      maxCapacity: 50,
      currentMembers: 31,
      status: SchemeStatusEnum.open,
      benefits: <String>[
        'Express Kitty: 50% Sponsored Bonus on Month 6',
        'Fast-track festival accumulation for Diwali & Dhanteras celebrations',
        'Instant hallmarked coin or ornament redemption',
      ],
      isPopular: false,
      bannerImageUrl: 'assets/images/banner_clean_coin.jpg',
    ),
  ];

  @override
  Future<List<SchemeEntity>> getActiveSchemes({int? durationFilter}) async {
    await _engineConfig.simulate();

    if (_shouldThrow) {
      throw const NetworkException('Failed to load active gold schemes.');
    }

    final List<SchemeEntity> schemes;
    if (_customSchemes != null) {
      schemes = _customSchemes!;
    } else {
      final List<dynamic> rawList =
          MockFixtures.activeSchemesJson['data']['schemes'] as List<dynamic>;

      schemes = rawList
          .map((dynamic json) =>
              SchemeMapper.toEntity(SchemeDto.fromJson(json as Map<String, dynamic>)))
          .toList();
    }

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

    if (_shouldThrow) {
      throw const NetworkException('Failed to load scheme details.');
    }

    final List<SchemeEntity> schemes = await getActiveSchemes();
    return schemes.firstWhere(
      (SchemeEntity s) => s.id == id,
      orElse: () => throw const NotFoundException(
        'Scheme not found with the requested ID.',
      ),
    );
  }
}
