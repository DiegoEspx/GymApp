import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/models/person.dart';
import 'package:proyectproducts/screens/login_screen.dart';
import 'edit_person_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PersonController personController = Get.put(PersonController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); // Nuevo controlador para la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 64, 255),
                Color.fromARGB(255, 3, 168, 245)
              ],
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 30,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Color.fromARGB(145, 4, 209, 241),
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Text(
                  "GymGuard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Color.fromARGB(145, 4, 209, 241),
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5),
            Text(
              "Client List",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1.2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: personController.persons.length,
                  itemBuilder: (context, index) {
                    Person person = personController.persons[index];
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
                                  person.remainingTime.value.isNotEmpty
                                      ? person.remainingTime.value
                                      : 'Ticket service activated',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: person.serviceKind.toLowerCase() ==
                                              'monthly'
                                          ? Colors.red
                                          : const Color.fromARGB(
                                              255, 36, 199, 178),
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
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                personController.deletePerson(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
                        labelText: 'Type of Service (monthly/ticket)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController, // Campo de contraseña
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
                        // Add the person
                        personController.addPerson(
                          Person(
                            name: nameController.text,
                            nPhone: phoneController.text,
                            license: licenseController.text,
                            serviceKind: serviceKindController.text,
                            dateEntry: DateTime.now(),
                            password: passwordController.text, // Contraseña
                          ),
                        );
                        // Clear fields
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
    Get.off(() => LoginScreen());
  }
}
