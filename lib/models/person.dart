import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Person {
  String id;  // Asumimos que el 'id' es ahora un campo obligatorio, pero será igual a 'license'
  String name;
  String nPhone;
  String license;
  String serviceKind;
  DateTime dateEntry;
  String password;
  String role; // Atributo para el rol
  RxString remainingTime = ''.obs; // Variable reactiva para tiempo restante

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
    required this.password,
    this.role = 'client', // Valor predeterminado para rol
  }) : id = license; // El ID es igual al valor de license

  // Constructor de Person a partir de JSON
  Person.fromJson(Map<String, dynamic> json)
      : id = json['license'],  // Asignamos 'license' como 'id'
        name = json['name'],
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
      'id': id,  // De todas formas, aseguramos incluir el 'id' al convertir a JSON
    };
  }
}

