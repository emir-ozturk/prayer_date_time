import '../entities/city.dart';
import '../repositories/prayer_repository.dart';

class GetCities {
  final PrayerRepository repository;

  const GetCities(this.repository);

  Future<List<City>> call() async {
    return await repository.getCities();
  }
}
