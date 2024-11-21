import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspaldaScreen extends StatefulWidget {
  const EspaldaScreen({super.key});

  @override
  _EspaldaScreenState createState() => _EspaldaScreenState();
}

class _EspaldaScreenState extends State<EspaldaScreen> {
  final exercises = [
    {"title": "Dominadas", "description": "Fortalece espalda alta y bíceps"},
    {"title": "Remo con barra", "description": "Mejora postura y espalda media"},
    {"title": "Jalón al pecho", "description": "Desarrolla dorsales y ancho"},
    {"title": "Peso muerto", "description": "Trabaja espalda baja y fuerza general"},
  ];

  // Estados de cada ejercicio
  final List<RxBool> exerciseCompleted = [];
  final RxInt completedExercises = 0.obs;

  // Cronómetro general de descanso
  final RxInt generalTimer = 120.obs; // 2 minutos en segundos
  Timer? generalTimerCountdown;

  // Cronómetro individual
  final Map<int, RxInt> individualTimers = {};

  @override
  void initState() {
    super.initState();

    // Inicializar estados
    for (var i = 0; i < exercises.length; i++) {
      exerciseCompleted.add(false.obs);
      individualTimers[i] = RxInt(60); // Cada ejercicio tiene 60 segundos
    }
  }

  void startGeneralTimer() {
    generalTimerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (generalTimer.value > 0) {
        generalTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void startIndividualTimer(int index) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (individualTimers[index]!.value > 0) {
        individualTimers[index]!.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void markAsComplete(int index) {
    exerciseCompleted[index].value = true;
    completedExercises.value++;

    if (completedExercises.value == exercises.length) {
      // Mostrar mensaje de éxito
      Get.snackbar(
        "¡Completaste todo!",
        "Has completado todos los ejercicios. ¡Buen trabajo!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Rutina de Espalda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    'Descanso general: ${generalTimer.value}s',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: exerciseCompleted[index].value
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 40)
                              : const Icon(Icons.access_time,
                                  color: Colors.blue, size: 40),
                          title: Text(
                            exercises[index]['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercises[index]['description']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              exerciseCompleted[index].value
                                  ? const Text(
                                      '¡Ejercicio completado!',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'Tiempo restante: ${individualTimers[index]!.value}s',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          ),
                          trailing: exerciseCompleted[index].value
                              ? null
                              : ElevatedButton(
                                  onPressed: () {
                                    startIndividualTimer(index);
                                  },
                                  child: const Text('Iniciar'),
                                ),
                          onTap: () {
                            if (!exerciseCompleted[index].value) {
                              markAsComplete(index);
                            }
                          },
                        ),
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: startGeneralTimer,
                child: const Text('Iniciar descanso general'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    generalTimerCountdown?.cancel();
    super.dispose();
  }
}
