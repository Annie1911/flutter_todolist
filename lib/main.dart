import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon Application',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark, // Utilisation du thème sombre
          primary: Colors.deepPurple, // Couleur principale
          secondary: Colors.lightBlue, // Couleur secondaire
          surface: Colors.grey[850]!, // Fond des surfaces (cartes, dialogues)
          background: Colors.black54, // Fond principal
          error: Colors.red, // Couleur pour les erreurs
          onPrimary: Colors.white, // Texte sur le fond primaire
          onSecondary: Colors.white, // Texte sur le fond secondaire
          onSurface: Colors.white, // Texte sur les surfaces
          onBackground: Colors.white, // Texte sur le fond principal
          onError: Colors.white, // Texte sur fond d'erreur
        ),
        useMaterial3: true, // Active le style Material 3
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple, // Couleur d'arrière-plan de l'AppBar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Fond de la barre de navigation
          selectedItemColor: Colors.purple, // Couleur des éléments sélectionnés
          unselectedItemColor: Colors.lightBlue, // Couleur des éléments non sélectionnés
        ),
        scaffoldBackgroundColor: Colors.white, // Fond global des écrans
      ),
      home: const RegistrationPage(), // Page de démarrage
    );
  }
}
