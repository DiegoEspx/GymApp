import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Person {
  String name;
  String nPhone;
  String license;
  String serviceKind;
  DateTime dateEntry;
  String password;
  String role; // Nuevo atributo para el rol
  RxString remainingTime = ''.obs; // Variable reactiva para tiempo restante

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
    required this.password,
    this.role = 'client', // Valor predeterminado para rol
  });

  // Constructor de Person a partir de JSON
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        nPhone = json['nPhone'],
        license = json['license'],
        serviceKind = json['serviceKind'],
        dateEntry = DateTime.parse(json['dateEntry']),
        password = json['password'],
        role = json['role'] ?? 'client'; // Si no está definido, será 'client'

  // Convertir Person a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nPhone': nPhone,
      'license': license,
      'serviceKind': serviceKind,
      'dateEntry': dateEntry.toIso8601String(),
      'password': password,
      'role': role,
    };
  }
}
