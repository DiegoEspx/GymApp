import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/models/person.dart';

class PersonController extends GetxController {
  final box = GetStorage(); // Instancia de GetStorage
  var persons = <Person>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPersons(); // Cargar personas al iniciar
  }

  // Método para guardar personas en el almacenamiento local
  void savePersons() {
    List<Map<String, dynamic>> personList =
        persons.map((person) => person.toJson()).toList();
    box.write('persons', personList);
  }

  // Método para cargar personas del almacenamiento local
  void loadPersons() {
    List<dynamic> storedPersons = box.read('persons') ?? [];
    persons
        .assignAll(storedPersons.map((data) => Person.fromJson(data)).toList());

    // Iniciar el temporizador para cada persona que tenga un servicio de mensualidad
    for (var person in persons) {
      if (person.serviceKind.toLowerCase() == 'monthly') {
        startTimer(person);
      }
    }
  }

  // Método para agregar una persona
  void addPerson(Person person) {
    persons.add(person);
    savePersons(); // Guardar después de agregar una persona
    if (person.serviceKind.toLowerCase() == 'monthly') {
      startTimer(person); // Iniciar temporizador si el servicio es mensualidad
    }
  }

  // Método para eliminar una persona
  void deletePerson(int index) {
    persons.removeAt(index);
    savePersons(); // Guardar después de eliminar una persona
  }

  // Método para editar una persona
  void editPerson(int index, Person updatedPerson) {
    persons[index] = updatedPerson;
    savePersons(); // Guardar después de editar una persona
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
