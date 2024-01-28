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
        // Customize the dark theme
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.black, // Set primary color to black
          secondary: Colors.red[900], // Set secondary color to dark red
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D), // Set scaffold background color
        cardColor: const Color(0xFF1A1A1A), // Set card background color
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white, // Set text body color to white
          displayColor: Colors.white, // Set text display color to white
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red[900], // Set FloatingActionButton background color
        ),
      ),
    );
  }
}
