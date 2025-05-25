import '../../domain/entities/district.dart';

class DistrictModel extends District {
  const DistrictModel({required super.id, required super.name, required super.cityId});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['IlceID'].toString(),
      name: json['IlceAdi'] ?? '',
      cityId: json['SehirID'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'IlceID': id, 'IlceAdi': name, 'SehirID': cityId};
  }

  factory DistrictModel.fromEntity(District district) {
    return DistrictModel(id: district.id, name: district.name, cityId: district.cityId);
  }
}
