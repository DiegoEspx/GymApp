import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/models/person.dart';
import 'edit_person_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PersonController personController = Get.put(PersonController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text("GymGuard"),
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
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Get.toNamed('/person');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_sharp),
              title: const Text('allusers'),
              onTap: () {
                Get.toNamed('/allusers');
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Person>>(
                stream: personController.getPersonStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay usuarios registrados',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  // Mostrar solo los últimos 3 usuarios
                  List<Person> latestUsers = snapshot.data!
                      .toList()
                      ..sort((a, b) => b.dateEntry.compareTo(a.dateEntry));
                  latestUsers = latestUsers.take(3).toList();

                  return ListView.builder(
                    itemCount: latestUsers.length,
                    itemBuilder: (context, index) {
                      Person person = latestUsers[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 13,
                        shadowColor: const Color.fromARGB(182, 0, 115, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          title: Text(
                            person.name,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 2, 0, 147),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone Number: ${person.nPhone}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('License: ${person.license}',
                                  style: const TextStyle(fontSize: 16)),
                              Text('Type of Service: ${person.serviceKind}',
                                  style: const TextStyle(fontSize: 16)),
                              Text(
                                  'Date of Entry: ${person.dateEntry.toLocal().toString().split(' ')[0]}',
                                  style: const TextStyle(fontSize: 16)),
                              Obx(
                                () {
                                  return Text(
                                    'Days remaining: ${person.remainingDays.value}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  );
                                },
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 33, 61, 243)),
                                onPressed: () {
                                  Get.to(() => EditPersonScreen(
                                      person: person, index: index));
                                },
                              ),
                              if (person.serviceKind.toLowerCase() ==
                                  'tiketera')
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.orange),
                                  onPressed: () {
                                    personController.reduceDays(person);
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  personController.deletePerson(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: licenseController,
                    decoration: InputDecoration(
                      labelText: 'License',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: serviceKindController,
                    decoration: InputDecoration(
                        labelText: 'Type of Service (monthly/tiketera)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          licenseController.text.isNotEmpty &&
                          serviceKindController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        personController.addPerson(
                          Person(
                            name: nameController.text,
                            nPhone: phoneController.text,
                            license: licenseController.text,
                            serviceKind: serviceKindController.text,
                            dateEntry: DateTime.now(),
                            password: passwordController.text,
                          ),
                        );
                        nameController.clear();
                        phoneController.clear();
                        licenseController.clear();
                        serviceKindController.clear();
                        passwordController.clear();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please complete all fields',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text('Add Customer'),
                  ),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    GetStorage().erase();
    Get.offAllNamed('/login');
  }
}

