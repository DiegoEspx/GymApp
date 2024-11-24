import 'package:flutter/material.dart';

import 'dart:async';

import 'package:get/get.dart';


 class BrazoScreen extends StatefulWidget {
  const BrazoScreen({super.key});

  @override
  _BrazoScreenState createState() => _BrazoScreenState();
}

class _BrazoScreenState extends State<BrazoScreen> {
  final exercises = [
    {
      "title": "Curl de bíceps con barra",
      "description": "Desarrolla fuerza y volumen en bíceps",
      "image": "assets/images/b1.webp"
    },
    {
      "title": "Extensiones de tríceps con cuerda",
      "description": "Fortalece tríceps y mejora definición",
      "image": "assets/images/b2jpg.jpg"
    },
    {
      "title": "Dominadas de agarre estrecho",
      "description": "Trabaja bíceps y antebrazos",
      "image": "assets/images/b3.webp"
    },
    {
      "title": "Dippings en paralelas",
      "description": "Fortalece tríceps, pecho y hombros",
      "image": "assets/images/b4.jpeg"
    }

  ];

  final List<RxBool> exerciseCompleted = [];
  final RxInt completedExercises = 0.obs;

  final RxInt generalTimer = 120.obs; // 2 minutos en segundos
  Timer? generalTimerCountdown;

  final Map<int, RxInt> individualTimers = {};

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < exercises.length; i++) {
      exerciseCompleted.add(false.obs);
      individualTimers[i] = RxInt(60);
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
          'Rutina de brazo',
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
              Obx(
                () => Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.shade400,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Descanso General:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${generalTimer.value}s',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercises[index]['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                exercises[index]['description']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.asset(
                                exercises[index]['image']!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              exerciseCompleted[index].value
                                  ? const Text(
                                      '¡Ejercicio completado!',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          'Tiempo restante: ${individualTimers[index]!.value}s',
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {
                                            startIndividualTimer(index);
                                          },
                                          child: const Text('Iniciar'),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
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
             ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/pose_detection'); // Navega a la pantalla de detección de poses
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple, // Color del botón
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Probar Pose Detection',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
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


