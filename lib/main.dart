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
          GetPage(name: '/user_details', page: () => const UserDetailsScreen())
        ],
      ),
    );
  }
}
