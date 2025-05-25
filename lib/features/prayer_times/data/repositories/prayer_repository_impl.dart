import '../../domain/entities/city.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/prayer_times.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_api_datasource.dart';
import '../datasources/prayer_local_datasource.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerApiDataSource apiDataSource;
  final PrayerLocalDataSource localDataSource;

  const PrayerRepositoryImpl({required this.apiDataSource, required this.localDataSource});

  @override
  Future<List<City>> getCities() async {
    return await apiDataSource.getCities();
  }

  @override
  Future<List<District>> getDistricts(String cityId) async {
    return await apiDataSource.getDistricts(cityId);
  }

  @override
  Future<List<PrayerTimes>> getPrayerTimes(String districtId) async {
    return await apiDataSource.getPrayerTimes(districtId);
  }

  @override
  Future<List<String>> getSavedCities() async {
    return await localDataSource.getSavedCities();
  }

  @override
  Future<void> saveCities(List<String> districtIds) async {
    await localDataSource.saveCities(districtIds);
  }

  @override
  Future<Map<String, String>> getSavedCityNames() async {
    return await localDataSource.getSavedCityNames();
  }

  @override
  Future<void> saveCityNames(Map<String, String> cityNames) async {
    await localDataSource.saveCityNames(cityNames);
  }

  @override
  Future<String?> getSelectedCityId() async {
    return await localDataSource.getSelectedCityId();
  }

  @override
  Future<void> saveSelectedCityId(String? cityId) async {
    await localDataSource.saveSelectedCityId(cityId);
  }
}
