import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyectproducts/models/person.dart';

class PersonController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instancia de Firestore
  var persons = <Person>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPersons(); // Cargar personas al iniciar
  }

  // Método para guardar personas en Firestore
  Future<void> savePersons() async {
    try {
      for (var person in persons) {
        // Usar el campo 'id' como identificador único para cada persona
        await firestore.collection('persons').doc(person.name).set({
          'name': person.name,
          'nPhone': person.nPhone,
          'license': person.license,
          'serviceKind': person.serviceKind,
          'dateEntry': person.dateEntry.toIso8601String(),
          'password': person.password,
        });
      }
    } catch (e) {
      print("Error al guardar persona: $e");
    }
  }

  // Método para cargar personas desde Firestore
  Future<void> loadPersons() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('persons').get();
      var docs = snapshot.docs;
      persons.assignAll(
        docs.map((doc) {
          return Person.fromJson({
            'name': doc['name'],
            'nPhone': doc['nPhone'],
            'license': doc['license'],
            'serviceKind': doc['serviceKind'],
            'dateEntry': DateTime.parse(doc['dateEntry']),
            'password': doc['password'],
          });
        }).toList(),
      );
    } catch (e) {
      print("Error al cargar personas: $e");
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
      await firestore
          .collection('persons')
          .doc(person.name)
          .delete(); // Eliminar de Firestore
      persons.removeAt(index);
    } catch (e) {
      print("Error al eliminar persona: $e");
    }
  }

  // Método para editar una persona en Firestore
  Future<void> editPerson(int index, Person updatedPerson) async {
    Person oldPerson = persons[index];
    try {
      await firestore.collection('persons').doc(oldPerson.name).update({
        'name': updatedPerson.name,
        'nPhone': updatedPerson.nPhone,
        'license': updatedPerson.license,
        'serviceKind': updatedPerson.serviceKind,
        'dateEntry': updatedPerson.dateEntry.toIso8601String(),
        'password': updatedPerson.password,
      });
      persons[index] = updatedPerson; // Actualizar la persona localmente
    } catch (e) {
      print("Error al editar persona: $e");
    }
  }

  // Calcular tiempo restante
  Map<String, int> calculateRemainingTime(Person person) {
    final now = DateTime.now();
    final endDate =
        person.dateEntry.add(const Duration(days: 30)); // Fecha final
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
        // Verificar que la persona todavía esté en la lista
        var remaining = calculateRemainingTime(person);
        person.remainingTime.value =
            'Time remaining: ${remaining['days']}d ${remaining['hours']}h ${remaining['minutes']}m ${remaining['seconds']}s';

        // Cancelar el temporizador si el tiempo ha expirado
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
