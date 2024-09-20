import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Person {
  String name;
  String nPhone;
  String license;
  String serviceKind;
  DateTime dateEntry;
  RxString remainingTime;

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
  }) : remainingTime = ''.obs;

  // Convertir Person a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nPhone': nPhone,
      'license': license,
      'serviceKind': serviceKind,
      'dateEntry': dateEntry.toIso8601String(),
    };
  }

  // Crear Person a partir de un mapa (JSON)
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      nPhone: json['nPhone'],
      license: json['license'],
      serviceKind: json['serviceKind'],
      dateEntry: DateTime.parse(json['dateEntry']),
    );
  }
}
