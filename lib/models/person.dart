import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Person {
  String id; // ID único para cada persona
  String name;
  String nPhone;
  String license;
  String serviceKind;
  DateTime dateEntry;
  RxString remainingTime;
  String password; // Añadido para la contraseña

  // Constructor que recibe todos los parámetros y el 'id' para identificar el documento
  Person({
    required this.id,
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
    required this.password, // Pasar la contraseña como parámetro
  }) : remainingTime = ''.obs;

  // Convertir Person a un mapa (JSON) para guardar en Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Incluir el ID en el JSON
      'name': name,
      'nPhone': nPhone,
      'license': license,
      'serviceKind': serviceKind,
      'dateEntry': dateEntry.toIso8601String(),
      'password': password, // Incluir la contraseña en el JSON
    };
  }

  // Crear Person a partir de un mapa (JSON)
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '', // Usar el 'id' si está presente
      name: json['name'] ?? 'Unknown', // Valor predeterminado si es null
      nPhone: json['nPhone'] ?? 'Unknown', // Valor predeterminado si es null
      license: json['license'] ?? 'Unknown', // Valor predeterminado si es null
      serviceKind:
          json['serviceKind'] ?? 'Unknown', // Valor predeterminado si es null
      dateEntry: DateTime.parse(json['dateEntry'] ??
          DateTime.now().toIso8601String()), // Manejo de fecha
      password: json['password'] ??
          '', // Asignar un valor predeterminado para la contraseña
    );
  }
}
