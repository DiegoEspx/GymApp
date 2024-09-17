import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/models/person.dart';
import 'edit_person_screen.dart'; // La pantalla para editar la persona

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final PersonController personController = Get.put(PersonController());

  // Controladores para los campos de entrada
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CLIENT LIST",
          style: TextStyle(
              fontWeight: FontWeight.bold, // Texto en negritas
              fontSize: 24, // Tamaño del texto
              letterSpacing: 1.5, // Espacio entre letras
              color: Colors.white),
        ),
        centerTitle: true, // Centrar el título
        backgroundColor:
            const Color.fromARGB(255, 89, 74, 255), // Cambiar el color de fondo
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
                      elevation: 14.0,
                      shadowColor: const Color.fromARGB(255, 15, 4, 168),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        title: Text(
                          person.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                            // Aquí va el nuevo Obx
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
                                          : Colors.green,
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
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty &&
                          licenseController.text.isNotEmpty &&
                          serviceKindController.text.isNotEmpty) {
                        // Agregar la persona
                        personController.addPerson(
                          Person(
                            name: nameController.text,
                            nPhone: phoneController.text,
                            license: licenseController.text,
                            serviceKind: serviceKindController.text,
                            dateEntry:
                                DateTime.now(), // Fecha de entrada actual
                          ),
                        );
                        // Limpiar los campos
                        nameController.clear();
                        phoneController.clear();
                        licenseController.clear();
                        serviceKindController.clear();
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
}
