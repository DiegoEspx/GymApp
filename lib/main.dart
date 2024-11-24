import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:proyectproducts/screens/allUsers_screen.dart';
import 'package:proyectproducts/screens/login_screen.dart';
import 'package:proyectproducts/screens/person_screen.dart';
import 'package:proyectproducts/screens/home_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/brazo_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/espalda_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pecho_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/pierna_screen.dart';
import 'package:proyectproducts/screens/person_subscreens/userDetails_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyectproducts/models/push_up_model.dart'; // Asegúrate de importar el modelo
import 'package:proyectproducts/views/pose_detection_view.dart';
 // Vista de detección de poses
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PushUpCounter(), // Inicialización de PushUpCounter
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GymGuard',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/login',
        getPages: [
          GetPage(name: '/login', page: () => LoginScreen()),
          GetPage(name: '/person', page: () => PersonScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/pecho', page: () => const PechoScreen()),
          GetPage(name: '/espalda', page: () => const EspaldaScreen()),
          GetPage(name: '/brazo', page: () => const BrazoScreen()),
          GetPage(name: '/pierna', page: () => const PiernaScreen()),
          GetPage(name: '/allusers', page: () => AllUsersScreen()),
          GetPage(name: '/user_details', page: () => const UserDetailsScreen()),
          GetPage(name: '/pose_detection', page: () => PoseDetectorView()), // Ruta para detección de poses
          GetPage(name: '/home_demo', page: () => const Home()), // Ruta para el Home adaptado
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google ML Kit Demo App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ExpansionTile(
                    title: const Text(
                      'Vision APIs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.visibility, color: Colors.blue),
                    children: [
                      CustomCard(
                        label: 'Pose Detection',
                        routeName: '/pose_detection', // Ruta para la vista de detección de poses
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String label;
  final String routeName; // En lugar de una vista, ahora usa una ruta de GetX
  final bool featureCompleted;

  const CustomCard({
    super.key,
    required this.label,
    required this.routeName,
    this.featureCompleted = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
        onTap: () {
          if (!featureCompleted) {
            Get.snackbar(
              'Funcionalidad no implementada',
              'Esta característica aún no está disponible.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.toNamed(routeName); // Navegación con GetX
          }
        },
      ),
    );
  }
}
