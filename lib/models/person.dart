import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';

class Person {
  String id; // ID del documento
  String name;
  String nPhone;
  String license;
  String serviceKind;
  DateTime dateEntry;
  String password;
  String role;
  RxInt remainingDays = 0.obs; // Días restantes como variable reactiva

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
    required this.password,
    this.role = 'client',
  }) : id = license;

  // Constructor desde Firestore (JSON)
  Person.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? '',
      name = json['name'] ?? '',
      nPhone = json['nPhone'] ?? '',
      license = json['license'] ?? '',
      serviceKind = json['serviceKind'] ?? '',
      dateEntry = json['dateEntry'] is Timestamp
          ? (json['dateEntry'] as Timestamp).toDate()
          : DateTime.parse(json['dateEntry']),
      password = json['password'] ?? '',
      role = json['role'] ?? 'client',
      remainingDays = RxInt(json['remainingDays'] ?? 0); // Valor por defecto

  // Conversión a JSON (para guardar en Firestore)
 Map<String, dynamic> toJson() {
  return {
    'id': id,
    'name': name,
    'nPhone': nPhone,
    'license': license,
    'serviceKind': serviceKind,
    'dateEntry': dateEntry.toIso8601String(),
    'password': password,
    'role': role,
    'remainingDays': remainingDays.value, // Sincroniza el valor reactivo
  };
}

}
