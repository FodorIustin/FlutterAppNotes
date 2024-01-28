import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'common/strings.dart' as strings;

void main() {
  runApp(const FirstApp());
}

class FirstApp extends StatelessWidget {
  const FirstApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appTitle,
      home: HomeScreen(),
      theme: ThemeData.dark().copyWith(
        // Culorile personalizate
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.black,
          secondary: Colors.red[900], // Culoarea roșu închis
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        cardColor: const Color(0xFF1A1A1A),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red[900], // Culoarea roșu închis a butonului de adăugare
        ),
      ),
    );
  }
}
