// lib/main.dart
import 'package:flutter/material.dart';
import 'ui/screens/main_screen.dart'; // This connects your Home Screen

void main() {
  runApp(const AlmirahApp());
}

class AlmirahApp extends StatelessWidget {
  const AlmirahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Almirah Store',
      debugShowCheckedModeBanner: false, // Removes the red "Debug" banner
      // Theme: We use a white background and clean colors like Myntra
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,

        // Define the colors for the app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF3F6C), // Myntra's signature pinkish-red
          surface: Colors.white,
        ),

        // Style the AppBar globally (Clean white look)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Text color
          elevation: 0, // Remove shadow for a flat look
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      // The entry point of your UI
      home: const MainScreen(),
    );
  }
}
