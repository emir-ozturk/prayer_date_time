import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/city_model.dart';
import '../models/district_model.dart';
import '../models/prayer_times_model.dart';

abstract class PrayerApiDataSource {
  Future<List<CityModel>> getCities();
  Future<List<DistrictModel>> getDistricts(String cityId);
  Future<List<PrayerTimesModel>> getPrayerTimes(String districtId);
}

class PrayerApiDataSourceImpl implements PrayerApiDataSource {
  final ApiClient apiClient;

  const PrayerApiDataSourceImpl({required this.apiClient});

  @override
  Future<List<CityModel>> getCities() async {
    final response = await apiClient.get(
      '${ApiConstants.citiesEndpoint}/${ApiConstants.turkeyCountryCode}',
    );

    List<dynamic> data;
    if (response is List) {
      data = response;
    } else if (response is Map && response['data'] != null) {
      data = response['data'] as List<dynamic>;
    } else {
      throw Exception('Unexpected API response format');
    }

    return data.map((json) => CityModel.fromJson(json)).toList();
  }

  @override
  Future<List<DistrictModel>> getDistricts(String cityId) async {
    final response = await apiClient.get('${ApiConstants.districtsEndpoint}/$cityId');

    List<dynamic> data;
    if (response is List) {
      data = response;
    } else if (response is Map && response['data'] != null) {
      data = response['data'] as List<dynamic>;
    } else {
      throw Exception('Unexpected API response format');
    }

    return data.map((json) => DistrictModel.fromJson(json)).toList();
  }

  @override
  Future<List<PrayerTimesModel>> getPrayerTimes(String districtId) async {
    final response = await apiClient.get('${ApiConstants.prayerTimesEndpoint}/$districtId');

    List<dynamic> data;
    if (response is List) {
      data = response;
    } else if (response is Map && response['data'] != null) {
      data = response['data'] as List<dynamic>;
    } else {
      throw Exception('Unexpected API response format');
    }

    return data.map((json) => PrayerTimesModel.fromJson(json)).toList();
  }
}
