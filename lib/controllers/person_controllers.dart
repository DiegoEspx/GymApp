import 'dart:async';
import 'package:get/get.dart';
import 'package:proyectproducts/models/person.dart';

class PersonController extends GetxController {
  var persons = <Person>[].obs;

  // Método para agregar personas
  void addPerson(Person person) {
    persons.add(person);
    if (person.serviceKind.toLowerCase() == 'monthly') {
      startTimer(person); // Iniciar el temporizador para la persona añadida
    }
  }

  // Método para eliminar personas
  void deletePerson(int index) {
    if (index >= 0 && index < persons.length) {
      persons.removeAt(index);
    }
  }

  // Método para editar personas
  void editPerson(int index, Person updatedPerson) {
    if (index >= 0 && index < persons.length) {
      persons[index] = updatedPerson;
      if (updatedPerson.serviceKind.toLowerCase() == 'monthly') {
        startTimer(
            updatedPerson); // Iniciar el temporizador para la persona editada
      }
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
