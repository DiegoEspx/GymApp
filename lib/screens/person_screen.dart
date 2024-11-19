import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/screens/person_subscreens/brazo_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/calendario_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/espalda_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pecho_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pierna_screen.dart';

class PersonScreen extends StatelessWidget {
  final Map<String, dynamic> personData =
      GetStorage().read('loggedInPerson') ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: personData.isEmpty
            ? const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${personData['name'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Phone: ${personData['nPhone'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'License: ${personData['license'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Service Type: ${personData['serviceKind'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Date of Entry: ${personData['dateEntry'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Mis Rutinas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const PechoScreen());
                            },
                            child: const Text('Pecho'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const EspaldaScreen());
                            },
                            child: const Text('Espalda'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const BrazoScreen());
                            },
                            child: const Text('Brazo'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const PiernaScreen());
                            },
                            child: const Text('Pierna'),
                          ),
                          

                        ],
                  ),
                  ElevatedButton(
                          onPressed: () {
                            Get.to(() => const CalendarScreen());
                          },
                          child: const Text('Abrir Calendario'),
                        ),

                        
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }

  void _logout() {
    GetStorage().erase(); // Borrar datos almacenados
    Get.offAllNamed('/login'); // Redirigir al LoginScreen usando la ruta nombrada
  }
}
