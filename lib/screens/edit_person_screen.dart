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
  final TextEditingController remainingDaysController = TextEditingController(); // Controller for remaining days

  final PersonController personController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Inicializamos los controladores con los valores actuales
    nameController.text = person.name;
    phoneController.text = person.nPhone;
    licenseController.text = person.license;
    serviceKindController.text = person.serviceKind;
    remainingDaysController.text = person.remainingDays.value.toString(); // Inicializar con el valor actual de días restantes

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
            const SizedBox(height: 10),

            // Campo de texto para los días restantes (remaining days)
            TextFormField(
              controller: remainingDaysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Remaining Days',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para guardar los cambios
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Calcular los días restantes basados en el tipo de servicio
                  int remainingDays = serviceKindController.text.toLowerCase() == 'monthly'
                      ? 30
                      : serviceKindController.text.toLowerCase() == 'tiketera'
                          ? 10
                          : int.tryParse(remainingDaysController.text) ?? person.remainingDays.value;

                  personController.editPerson(
                    index,
                    Person(
                      name: nameController.text,
                      nPhone: phoneController.text,
                      license: licenseController.text,
                      serviceKind: serviceKindController.text,
                      dateEntry: person.dateEntry,
                      password: person.password,
                      role: person.role,
                    )..remainingDays.value = remainingDays,  // Actualizar los días restantes
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
