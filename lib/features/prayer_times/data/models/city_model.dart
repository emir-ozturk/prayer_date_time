import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({required super.id, required super.name, required super.countryCode});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['SehirID'].toString(),
      name: json['SehirAdi'] ?? '',
      countryCode: json['UlkeID'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'SehirID': id, 'SehirAdi': name, 'UlkeID': countryCode};
  }

  factory CityModel.fromEntity(City city) {
    return CityModel(id: city.id, name: city.name, countryCode: city.countryCode);
  }
}
