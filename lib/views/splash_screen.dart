import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:proyectproducts/views/pose_detection_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Customizable texts
  static const String appName = 'My Personal Trainer';
  static const String pushUpCountLabel = 'Push-Up Counter';

  // Text style for titles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.orange, // Changed to orange
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Button style
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffF27338), // Button color modified
      minimumSize: Size(size.width * 0.85, 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: titleStyle,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
      ),
      backgroundColor: const Color(0xffF5F5F5),
      body: Center(
        child: SingleChildScrollView( // To avoid issues on smaller screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/push-up-animation.json', 
                fit: BoxFit.cover,
                height: 200, // Size adjusted for better visualization
              ),
              const SizedBox(height: 40),
              Text(
                pushUpCountLabel,
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Custom font
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Start your workout now!', // Motivational text
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto', // Custom font
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PoseDetectorView()),
                  );
                },
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto', // Custom font
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
