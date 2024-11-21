import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_default.png'), // Cambia la ruta si tienes la imagen en otro lugar
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
      storage.write('role', 'admin');
      Get.off(() => HomeScreen());
    } else {
      _loginAsPerson(username, password);
    }
  }

  // Método para verificar si la persona existe en Firestore
  Future<void> _loginAsPerson(String license, String password) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('persons')
          .where('license', isEqualTo: license)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var personData = querySnapshot.docs.first.data();
        GetStorage().write('loggedInPerson', personData);
        GetStorage().write('role', 'persona');
        Get.off(() => PersonScreen());
      } else {
        Get.snackbar('Error', 'Credenciales incorrectas',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un problema al autenticarte: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
