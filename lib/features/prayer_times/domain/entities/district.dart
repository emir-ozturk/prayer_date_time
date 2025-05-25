import 'package:equatable/equatable.dart';

class District extends Equatable {
  final String id;
  final String name;
  final String cityId;

  const District({required this.id, required this.name, required this.cityId});

  @override
  List<Object> get props => [id, name, cityId];

  @override
  String toString() => 'District(id: $id, name: $name, cityId: $cityId)';
}
