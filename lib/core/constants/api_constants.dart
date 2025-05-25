class ApiConstants {
  static const String baseUrl = 'https://ezanvakti.emushaf.net';

  static const String countriesEndpoint = '/ulkeler';
  static const String citiesEndpoint = '/sehirler';
  static const String districtsEndpoint = '/ilceler';
  static const String prayerTimesEndpoint = '/vakitler';

  // Turkey country code for default cities
  static const String turkeyCountryCode = '2';

  // Rate limiting info from API
  static const int requestLimitPer5Minutes = 30;
  static const int requestLimitPerDay = 200;

  static const Duration timeoutDuration = Duration(seconds: 10);
}
