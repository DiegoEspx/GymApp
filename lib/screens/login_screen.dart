import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'home_screen.dart';
import 'person_screen.dart';

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final GetStorage storage = GetStorage();

  // Lista de admins predeterminados
  final List<Map<String, String>> admins = [
    {'username': 'admin1', 'password': 'admin123'},
    {'username': 'admin2', 'password': 'admin456'},
    // Agrega más admins aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para simular el login
  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Comprobar si las credenciales corresponden a un admin
    final admin = admins.firstWhere(
      (admin) => admin['username'] == username && admin['password'] == password,
      orElse: () => {},
    );

    if (admin.isNotEmpty) {
      // Si se encuentra el admin, simula que el rol es 'admin'
      storage.write('role', 'admin');
      // Redirigir a la pantalla de admin (HomeScreen)
      Get.off(() => HomeScreen());
    } else {
      // Si no es admin, verificamos si es una persona en Firestore
      _loginAsPerson(username, password);
    }
  }

  // Método para verificar si la persona existe en Firestore
  Future<void> _loginAsPerson(String license, String password) async {
    try {
      // Consulta a Firestore para verificar si existe una persona con esa cédula y contraseña
      var querySnapshot = await FirebaseFirestore.instance
          .collection('persons')
          .where('license', isEqualTo: license)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si se encuentra un documento que coincide con la cédula y la contraseña
        storage.write('role', 'persona');
        // Redirigir a la pantalla de persona (PersonScreen)
        Get.off(() => PersonScreen());
      } else {
        // Si no se encuentra la persona con esas credenciales, mostramos un mensaje de error
        Get.snackbar('Error', 'Credenciales incorrectas',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Si hay un error con la consulta a Firestore, mostramos un mensaje
      Get.snackbar('Error', 'Hubo un problema al autenticarte: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
