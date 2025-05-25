import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;
  final String countryCode;

  const City({required this.id, required this.name, required this.countryCode});

  @override
  List<Object> get props => [id, name, countryCode];

  @override
  String toString() => 'City(id: $id, name: $name, countryCode: $countryCode)';
}
