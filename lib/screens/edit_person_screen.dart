import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/models/person.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';

class EditPersonScreen extends StatelessWidget {
  final Person person;
  final int index;

  EditPersonScreen({super.key, required this.person, required this.index});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController serviceKindController = TextEditingController();

  final PersonController personController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Inicializamos los controladores con los valores actuales
    nameController.text = person.name;
    phoneController.text = person.nPhone;
    licenseController.text = person.license;
    serviceKindController.text = person.serviceKind;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto para el nombre
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el teléfono
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para la cédula (license)
            TextFormField(
              controller: licenseController,
              decoration: InputDecoration(
                labelText: 'License',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el tipo de servicio
            TextFormField(
              controller: serviceKindController,
              decoration: InputDecoration(
                labelText: 'Type of Service',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para guardar los cambios
            Center(
              child: ElevatedButton(
                onPressed: () {
                  personController.editPerson(
                    index,
                    Person(
                      name: nameController.text,
                      nPhone: phoneController.text,
                      license: licenseController.text, // License es el ID
                      serviceKind: serviceKindController.text,
                      dateEntry: person.dateEntry, // Mantener la misma fecha de entrada
                      password: person.password, // Mantener el mismo password
                      role: person.role, // Mantener el mismo rol (si es necesario)
                    ),
                  );
                  Get.back(); // Volver a la pantalla anterior
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
