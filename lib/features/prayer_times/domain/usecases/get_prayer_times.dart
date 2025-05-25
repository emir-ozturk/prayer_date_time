import '../entities/prayer_times.dart';
import '../repositories/prayer_repository.dart';

class GetPrayerTimes {
  final PrayerRepository repository;

  const GetPrayerTimes(this.repository);

  Future<List<PrayerTimes>> call(String districtId) async {
    return await repository.getPrayerTimes(districtId);
  }
}
