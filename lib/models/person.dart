import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Person {
  String name;
  String nPhone;
  String license;
  String serviceKind; // 'monthly' o 'ticket'
  DateTime dateEntry;
  RxString remainingTime = ''.obs; // Propiedad reactiva para el tiempo restante

  Person({
    required this.name,
    required this.nPhone,
    required this.license,
    required this.serviceKind,
    required this.dateEntry,
  });
}
