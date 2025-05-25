import 'package:shared_preferences/shared_preferences.dart';

import '../../features/prayer_times/data/datasources/prayer_api_datasource.dart';
import '../../features/prayer_times/data/datasources/prayer_local_datasource.dart';
import '../../features/prayer_times/data/repositories/prayer_repository_impl.dart';
import '../../features/prayer_times/domain/repositories/prayer_repository.dart';
import '../../features/prayer_times/domain/usecases/get_cities.dart';
import '../../features/prayer_times/domain/usecases/get_districts.dart';
import '../../features/prayer_times/domain/usecases/get_prayer_times.dart';
import '../network/api_client.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core
  late final ApiClient _apiClient;
  late final SharedPreferences _sharedPreferences;

  // Data Sources
  late final PrayerApiDataSource _prayerApiDataSource;
  late final PrayerLocalDataSource _prayerLocalDataSource;

  // Repository
  late final PrayerRepository _prayerRepository;

  // Use Cases
  late final GetCities _getCities;
  late final GetDistricts _getDistricts;
  late final GetPrayerTimes _getPrayerTimes;

  Future<void> init() async {
    // Initialize SharedPreferences
    _sharedPreferences = await SharedPreferences.getInstance();

    // Initialize Core
    _apiClient = ApiClient();

    // Initialize Data Sources
    _prayerApiDataSource = PrayerApiDataSourceImpl(apiClient: _apiClient);
    _prayerLocalDataSource = PrayerLocalDataSourceImpl(sharedPreferences: _sharedPreferences);

    // Initialize Repository
    _prayerRepository = PrayerRepositoryImpl(
      apiDataSource: _prayerApiDataSource,
      localDataSource: _prayerLocalDataSource,
    );

    // Initialize Use Cases
    _getCities = GetCities(_prayerRepository);
    _getDistricts = GetDistricts(_prayerRepository);
    _getPrayerTimes = GetPrayerTimes(_prayerRepository);
  }

  // Getters
  ApiClient get apiClient => _apiClient;
  SharedPreferences get sharedPreferences => _sharedPreferences;
  PrayerRepository get prayerRepository => _prayerRepository;
  GetCities get getCities => _getCities;
  GetDistricts get getDistricts => _getDistricts;
  GetPrayerTimes get getPrayerTimes => _getPrayerTimes;

  void dispose() {
    _apiClient.dispose();
  }
}
