import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyectproducts/models/person.dart';

class PersonController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var persons = <Person>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Escucha los cambios en la colección y actualiza la lista local
    getPersonStream().listen((users) {
      persons.assignAll(users);
    });
  }

  // Obtener usuarios de Firestore como Stream
  Stream<List<Person>> getPersonStream() {
    return firestore.collection('persons').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Actualiza el campo remainingDays si no existe en Firestore
        if (!(doc.data() as Map<String, dynamic>).containsKey('remainingDays')) {
          firestore.collection('persons').doc(doc.id).update({
            'remainingDays': 0,
          });
        }
        return Person.fromJson({
          'id': doc.id, // ID del documento
          ...doc.data() as Map<String, dynamic>, // Datos del documento
        });
      }).toList();
    });
  }

  // Guardar todos los usuarios en Firestore (sincronización manual)
  Future<void> savePersons() async {
    try {
      for (var person in persons) {
        await firestore.collection('persons').doc(person.license).set(person.toJson());
      }
    } catch (e) {
      print("Error al guardar usuarios: $e");
    }
  }

  // Agregar un nuevo usuario
  Future<void> addPerson(Person person) async {
  try {
    // Subir el usuario a Firestore usando 'license' como ID único
    await firestore.collection('persons').doc(person.license).set(person.toJson());

    // Agregar el usuario a la lista local para que se refleje en tiempo real
    persons.add(person);

    // Configurar días restantes según el tipo de servicio
    if (person.serviceKind.toLowerCase() == 'monthly') {
      person.remainingDays.value = 30; // Días iniciales para mensualidad
      startTimer(person); // Iniciar temporizador
    } else if (person.serviceKind.toLowerCase() == 'tiketera') {
      person.remainingDays.value = 10; // Días iniciales para tiketera
    }

    print("Usuario agregado exitosamente: ${person.name}");
  } catch (e) {
    print("Error al agregar usuario: $e");
    Get.snackbar('Error', 'No se pudo agregar el usuario: $e',
        snackPosition: SnackPosition.BOTTOM);
  }
}


  // Eliminar un usuario
  Future<void> deletePerson(int index) async {
    Person person = persons[index];
    try {
      await firestore.collection('persons').doc(person.license).delete(); // Eliminar en Firestore
      persons.removeAt(index); // Eliminar localmente
    } catch (e) {
      print("Error al eliminar persona: $e");
    }
  }

  // Editar un usuario
  Future<void> editPerson(int index, Person updatedPerson) async {
    try {
      await firestore
          .collection('persons')
          .doc(updatedPerson.license)
          .update(updatedPerson.toJson()); // Actualizar en Firestore
      persons[index] = updatedPerson; // Actualizar localmente
    } catch (e) {
      print("Error al editar persona: $e");
    }
  }

  // Reducir días manualmente para usuarios con tiketera
  void reduceDays(Person person) {
    if (person.serviceKind.toLowerCase() == 'tiketera' &&
        person.remainingDays.value > 0) {
      person.remainingDays.value -= 1; // Reducir días restantes
      syncRemainingDays(person); // Sincronizar con Firestore
    } else {
      Get.snackbar('Error', 'No quedan días disponibles para este usuario',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Calcular tiempo restante para mensualidad
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

  // Actualizar tiempo restante cada segundo para usuarios de mensualidad
  void startTimer(Person person) {
    Timer.periodic(const Duration(hours: 24), (timer) {
      if (persons.contains(person) && person.serviceKind.toLowerCase() == 'monthly') {
        person.remainingDays.value -= 1; // Reducir días restantes
        syncRemainingDays(person); // Sincronizar con Firestore

        if (person.remainingDays.value <= 0) {
          person.remainingDays.value = 0; // Evitar valores negativos
          timer.cancel(); // Detener el temporizador
        }
      } else {
        timer.cancel(); // Detener si el usuario no es mensualidad
      }
    });
  }

  // Sincronizar días restantes con Firestore
  void syncRemainingDays(Person person) {
    firestore.collection('persons').doc(person.license).update({
      'remainingDays': person.remainingDays.value,
    });
  }
  Stream<List<Person>> getRecentPersonStream() {
  // Obtiene el tiempo actual y resta 5 minutos
  DateTime fiveMinutesAgo = DateTime.now().subtract(const Duration(minutes: 5));

  return firestore
      .collection('persons')
      .where('dateEntry', isGreaterThan: fiveMinutesAgo) // Filtra por dateEntry mayor a hace 5 minutos
      .snapshots()
      .map((snapshot) {
    // Mapea los documentos obtenidos a una lista de objetos Person
    return snapshot.docs.map((doc) {
      return Person.fromJson({
        'id': doc.id, // Incluye el ID del documento
        ...doc.data() as Map<String, dynamic>, // Los datos del documento
      });
    }).toList();
  });
}

}
