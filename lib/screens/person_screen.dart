import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/screens/person_subscreens/brazo_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/calendario_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/espalda_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pecho_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pierna_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/userDetails_screen.dart';

class PersonScreen extends StatelessWidget {
  final Map<String, dynamic> personData =
      GetStorage().read('loggedInPerson') ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 64, 255),
                    Color.fromARGB(255, 3, 168, 245),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Menú de Navegación',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Abrir Calendario'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => CalendarScreen(
                  license: personData['license'] ?? '',
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Detalles del Servicio'),
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Get.to(() => const UserDetailsScreen()); // Navega a UserDetailsScreen
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: personData.isEmpty
              ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${personData['name'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Phone: ${personData['nPhone'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Mis Rutinas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildRoutineButton(
                          context,
                          title: 'Pecho',
                          icon: Icons.fitness_center,
                          color: Colors.pinkAccent,
                          onTap: () => Get.to(() => const PechoScreen()),
                        ),
                        _buildRoutineButton(
                          context,
                          title: 'Espalda',
                          icon: Icons.fitness_center,
                          color: Colors.blue,
                          onTap: () => Get.to(() => const EspaldaScreen()),
                        ),
                        _buildRoutineButton(
                          context,
                          title: 'Brazo',
                          icon: Icons.fitness_center,
                          color: Colors.orangeAccent,
                          onTap: () => Get.to(() => const BrazoScreen()),
                        ),
                        _buildRoutineButton(
                          context,
                          title: 'Pierna',
                          icon: Icons.fitness_center,
                          color: Colors.green,
                          onTap: () => Get.to(() => const PiernaScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    
                    
                    
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildRoutineButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
