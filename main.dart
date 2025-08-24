import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz_screen.dart';
import 'package:quiz_app/widgets/scanlines.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEURAL LINK PROTOCOL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00FFFF),
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFFF),
          secondary: Color(0xFF7C4DFF),
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF0A0A0F),
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onSurface: Color(0xFF00FFFF),
          onBackground: Color(0xFF00FFFF),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF00FFFF),
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF00FFFF),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF00FFFF),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'monospace',
            color: Color(0xFF00FFFF),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF00FFFF),
            side: const BorderSide(color: Color(0xFF00FFFF), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A1A2E).withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF00FFFF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF00FFFF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF666688),
            fontFamily: 'monospace',
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF00FFFF),
            fontFamily: 'monospace',
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0F),
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'monospace',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FFFF),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const CyberpunkQuizHome(),
    );
  }
}

class CyberpunkQuizHome extends StatelessWidget {
  const CyberpunkQuizHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 2.0,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF0A0A0F),
                ],
              ),
            ),
          ),
          // Scanlines overlay
          const Scanlines(opacity: 0.08),
          // Main content
          const QuizScreen(),
        ],
      ),
    );
  }
}