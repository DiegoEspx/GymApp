import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyectproducts/controllers/person_controllers.dart';
import 'package:proyectproducts/models/person.dart';
import 'edit_person_screen.dart';



class AllUsersScreen extends StatelessWidget {
  AllUsersScreen({super.key});

  final PersonController personController = Get.put(PersonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos los Usuarios'),
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
      ),
      body: SafeArea(
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

            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                Person person = users[index];
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                        if (person.serviceKind.toLowerCase() == 'tiketera')
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.orange),
                            onPressed: () {
                              personController.reduceDays(person);
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
            );
          },
        ),
      ),
    );
  }
}

