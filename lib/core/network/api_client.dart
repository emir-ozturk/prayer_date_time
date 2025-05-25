import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    try {
      final response = await _client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'User-Agent': 'PrayerTimes/1.0',
            },
          )
          .timeout(ApiConstants.timeoutDuration);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return json.decode(decodedBody);
      } else {
        throw ApiException(
          'API request failed with status: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException catch (e) {
      throw ApiException('İnternet bağlantısı hatası: ${e.message}');
    } on HttpException catch (e) {
      throw ApiException('HTTP hatası: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Veri formatı hatası: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Ağ hatası: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message';
}
