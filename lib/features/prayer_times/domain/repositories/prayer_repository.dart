import '../entities/city.dart';
import '../entities/district.dart';
import '../entities/prayer_times.dart';

abstract class PrayerRepository {
  Future<List<City>> getCities();
  Future<List<District>> getDistricts(String cityId);
  Future<List<PrayerTimes>> getPrayerTimes(String districtId);
  Future<List<String>> getSavedCities();
  Future<void> saveCities(List<String> districtIds);
  Future<Map<String, String>> getSavedCityNames();
  Future<void> saveCityNames(Map<String, String> cityNames);
  Future<String?> getSelectedCityId();
  Future<void> saveSelectedCityId(String? cityId);
}
