import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Importe Sizer
import 'screens/splash_screen.dart'; // Importe le Splash Screen
import 'screens/home_screen.dart';   // Importe l'écran principal (HomeScreen)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Gestion de Scolarité',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
          },
        );
      },
    );
  }
}