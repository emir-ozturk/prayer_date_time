import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class PrayerLocalDataSource {
  Future<List<String>> getSavedCities();
  Future<void> saveCities(List<String> districtIds);
  Future<Map<String, String>> getSavedCityNames();
  Future<void> saveCityNames(Map<String, String> cityNames);
  Future<String?> getSelectedCityId();
  Future<void> saveSelectedCityId(String? cityId);
}

class PrayerLocalDataSourceImpl implements PrayerLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String savedCitiesKey = 'saved_cities';
  static const String savedCityNamesKey = 'saved_city_names';
  static const String selectedCityIdKey = 'selected_city_id';

  const PrayerLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getSavedCities() async {
    final jsonString = sharedPreferences.getString(savedCitiesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<String>();
    }
    return [];
  }

  @override
  Future<void> saveCities(List<String> districtIds) async {
    final jsonString = json.encode(districtIds);
    await sharedPreferences.setString(savedCitiesKey, jsonString);
  }

  @override
  Future<Map<String, String>> getSavedCityNames() async {
    final jsonString = sharedPreferences.getString(savedCityNamesKey);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.cast<String, String>();
    }
    return {};
  }

  @override
  Future<void> saveCityNames(Map<String, String> cityNames) async {
    final jsonString = json.encode(cityNames);
    await sharedPreferences.setString(savedCityNamesKey, jsonString);
  }

  @override
  Future<String?> getSelectedCityId() async {
    return sharedPreferences.getString(selectedCityIdKey);
  }

  @override
  Future<void> saveSelectedCityId(String? cityId) async {
    if (cityId != null) {
      await sharedPreferences.setString(selectedCityIdKey, cityId);
    } else {
      await sharedPreferences.remove(selectedCityIdKey);
    }
  }
}
