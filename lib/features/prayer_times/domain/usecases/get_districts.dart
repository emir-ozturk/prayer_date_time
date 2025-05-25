import '../entities/district.dart';
import '../repositories/prayer_repository.dart';

class GetDistricts {
  final PrayerRepository repository;

  const GetDistricts(this.repository);

  Future<List<District>> call(String cityId) async {
    return await repository.getDistricts(cityId);
  }
}
