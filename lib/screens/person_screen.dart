import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/screens/login_screen.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persona Screen'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido, Persona!',
              style: TextStyle(fontSize: 24),
            ),
            // Aquí puedes agregar más contenido específico para la persona
          ],
        ),
      ),
    );
  }

  // Método para cerrar sesión
  void _logout() {
    // Limpiar el rol almacenado en GetStorage
    GetStorage().erase();
    // Redirigir al LoginScreen
    Get.off(() => LoginScreen());
  }
}
