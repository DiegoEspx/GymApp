import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyectproducts/models/person.dart';

class PersonController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Instancia de Firestore
  var persons = <Person>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Aquí ya no necesitamos cargar las personas manualmente
  }

  // Método para guardar personas en Firestore
  Future<void> savePersons() async {
    try {
      for (var person in persons) {
        // Usar 'license' como ID único para cada persona en Firestore
        await firestore.collection('persons').doc(person.license).set({
          'id': person.license, // Usamos license como ID
          'name': person.name,
          'nPhone': person.nPhone,
          'license': person.license,
          'serviceKind': person.serviceKind,
          'dateEntry': Timestamp.fromDate(person.dateEntry), // Convertir DateTime a Timestamp
          'password': person.password,
          'role': person.role,
        });
      }
    } catch (e) {
      print("Error al guardar persona: $e");
    }
  }

  // Método para agregar una persona
  Future<void> addPerson(Person person) async {
    persons.add(person);
    await savePersons(); // Guardar en Firestore después de agregar
    if (person.serviceKind.toLowerCase() == 'monthly') {
      startTimer(person); // Iniciar temporizador si el servicio es mensualidad
    }
  }

  // Método para eliminar una persona de Firestore
  Future<void> deletePerson(int index) async {
    Person person = persons[index];
    try {
      await firestore.collection('persons').doc(person.license).delete(); // Usamos el 'license' como ID
      persons.removeAt(index);
    } catch (e) {
      print("Error al eliminar persona: $e");
    }
  }

  // Método para editar una persona en Firestore
  Future<void> editPerson(int index, Person updatedPerson) async {
    Person oldPerson = persons[index];
    try {
      await firestore.collection('persons').doc(oldPerson.license).update({
        'name': updatedPerson.name,
        'nPhone': updatedPerson.nPhone,
        'license': updatedPerson.license,
        'serviceKind': updatedPerson.serviceKind,
        'dateEntry': updatedPerson.dateEntry.toIso8601String(),
        'password': updatedPerson.password,
        'role': updatedPerson.role,
      });
      persons[index] = updatedPerson; // Actualizar la persona localmente
    } catch (e) {
      print("Error al editar persona: $e");
    }
  }

  // Obtener stream de personas desde Firestore (actualización en tiempo real)
  Stream<List<Person>> getPersonStream() {
    return firestore.collection('persons').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var dateEntry = doc['dateEntry'];
        return Person.fromJson({
          'id': doc['id'], // ID obtenido de Firestore
          'name': doc['name'],
          'nPhone': doc['nPhone'],
          'license': doc['license'],
          'serviceKind': doc['serviceKind'],
          'dateEntry': (dateEntry is Timestamp)
              ? dateEntry.toDate()
              : DateTime.parse(dateEntry),
          'password': doc['password'],
          'role': doc['role'] ?? 'client',
        });
      }).toList();
    });
  }

  // Calcular tiempo restante
  Map<String, int> calculateRemainingTime(Person person) {
    final now = DateTime.now();
    final endDate = person.dateEntry.add(const Duration(days: 30)); // Fecha final
    final timeDifference = endDate.difference(now);

    int remainingDays = timeDifference.inDays;
    int remainingHours = timeDifference.inHours % 24;
    int remainingMinutes = timeDifference.inMinutes % 60;
    int remainingSeconds = timeDifference.inSeconds % 60;

    return {
      'days': remainingDays,
      'hours': remainingHours,
      'minutes': remainingMinutes,
      'seconds': remainingSeconds
    };
  }

  // Actualizar tiempo restante cada segundo
  void startTimer(Person person) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (persons.contains(person)) {
        var remaining = calculateRemainingTime(person);
        person.remainingTime.value =
            'Time remaining: ${remaining['days']}d ${remaining['hours']}h ${remaining['minutes']}m ${remaining['seconds']}s';

        if ((remaining['days'] ?? 0) <= 0 &&
            (remaining['hours'] ?? 0) <= 0 &&
            (remaining['minutes'] ?? 0) <= 0 &&
            (remaining['seconds'] ?? 0) <= 0) {
          person.remainingTime.value = 'Expired';
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }
}
