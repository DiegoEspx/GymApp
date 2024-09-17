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
    // Prellenar los TextEditingController con los valores actuales
    nameController.text = person.name;
    phoneController.text = person.nPhone;
    licenseController.text = person.license;
    serviceKindController.text = person.serviceKind;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Persona'),
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
                labelText: 'Nombre',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el teléfono
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para la cédula
            TextFormField(
              controller: licenseController,
              decoration: InputDecoration(
                labelText: 'Cédula',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),

            // Campo de texto para el tipo de servicio
            TextFormField(
              controller: serviceKindController,
              decoration: InputDecoration(
                labelText: 'Tipo de Servicio',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
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
                      license: licenseController.text,
                      serviceKind: serviceKindController.text,
                      dateEntry: person
                          .dateEntry, // Mantenemos la misma fecha de entrada
                    ),
                  );
                  Get.back(); // Volver a la pantalla anterior
                },
                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
