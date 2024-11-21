import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/models/person.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/screens/person_subscreens/QR_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final PersonController personController = Get.put(PersonController());
  final GetStorage storage = GetStorage();
  late Person loggedInPerson;
  late Timer timer;

  Map<String, int> remainingTime = {'days': 0, 'hours': 0, 'minutes': 0, 'seconds': 0};

  @override
  void initState() {
    super.initState();
    // Obtener los datos del usuario logueado desde GetStorage
    Map<String, dynamic> personData = storage.read('loggedInPerson') ?? {};
    loggedInPerson = Person.fromJson(personData);

    if (loggedInPerson.serviceKind.toLowerCase() == 'monthly') {
      // Inicializar el temporizador para usuarios de mensualidad
      calculateRemainingTime();
      timer = Timer.periodic(const Duration(seconds: 1), (_) => calculateRemainingTime());
    }
  }

  @override
  void dispose() {
    if (loggedInPerson.serviceKind.toLowerCase() == 'monthly') {
      timer.cancel(); // Detener el temporizador al salir de la página
    }
    super.dispose();
  }

  // Calcular el tiempo restante para usuarios de mensualidad
  void calculateRemainingTime() {
    final now = DateTime.now();
    final endDate = loggedInPerson.dateEntry.add(const Duration(days: 30));
    final difference = endDate.difference(now);

    setState(() {
      remainingTime = {
        'days': difference.inDays,
        'hours': difference.inHours % 24,
        'minutes': difference.inMinutes % 60,
        'seconds': difference.inSeconds % 60,
      };
    });
  }

  // Usar un ticket para usuarios con tiketera
  void useTicket() {
    if (loggedInPerson.remainingDays.value > 0) {
      setState(() {
        loggedInPerson.remainingDays.value -= 1;
      });
      // Sincronizar cambios con Firestore
      personController.syncRemainingDays(loggedInPerson);
      Get.snackbar(
        'Éxito',
        'Has usado un ticket. Tickets restantes: ${loggedInPerson.remainingDays.value}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'No tienes tickets restantes.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Usuario'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 64, 255),
                Color.fromARGB(255, 3, 168, 245),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 3, 168, 245),
              Color.fromARGB(255, 0, 64, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  loggedInPerson.serviceKind.toLowerCase() == 'monthly'
                      ? Icons.timer
                      : Icons.confirmation_num,
                  size: 50,
                  color: const Color.fromARGB(255, 3, 168, 245),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Bienvenido, ${loggedInPerson.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              if (loggedInPerson.serviceKind.toLowerCase() == 'monthly')
                Column(
                  children: [
                    const Text(
                      'Tiempo Restante de la Membresía:',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${remainingTime['days']} días, ${remainingTime['hours']} horas, ${remainingTime['minutes']} minutos, ${remainingTime['seconds']} segundos',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                if (loggedInPerson.serviceKind.toLowerCase() == 'tiketera')
                  Column(
                    children: [
                      const Text(
                        'Tickets Restantes:',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(
                          () => Text(
                            '${loggedInPerson.remainingDays.value}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 87, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => QRScannerScreen(loggedInPerson: loggedInPerson));
                        },
                        child: const Text(
                          'Escanear QR para usar Ticket',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}


