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
          brightness: Brightness.dark, // Thème sombre
          primary: Colors.amber, // Couleur principale (vibrante et moderne)
          secondary: Colors.cyanAccent, // Couleur secondaire
          surface: Colors.grey[800]!, // Fond des surfaces (cartes, dialogues)
          background: Colors.black, // Fond global des écrans
          error: Colors.pinkAccent, // Couleur pour les erreurs
          onPrimary: Colors.black, // Texte sur le fond principal (contraste élevé)
          onSecondary: Colors.black, // Texte sur le fond secondaire
          onSurface: Colors.white70, // Texte sur les surfaces
          onError: Colors.red, // Texte sur fond d'erreur
        ),
        useMaterial3: true, // Style Material 3 activé
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber, // Couleur AppBar
          foregroundColor: Colors.black, // Texte et icônes AppBar
          elevation: 2, // Léger effet d'ombre pour la profondeur
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[850], // Fond de la barre de navigation
          selectedItemColor: Colors.amber, // Couleur des éléments sélectionnés
          unselectedItemColor: Colors.cyanAccent.withOpacity(0.7), // Couleur des éléments non sélectionnés
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.cyanAccent, // Couleur du FAB
          foregroundColor: Colors.black, // Couleur du texte/icône sur le FAB
        ),
        cardColor: Colors.grey[850], // Couleur des cartes
        dialogBackgroundColor: Colors.grey[900], // Couleur des dialogues
        scaffoldBackgroundColor: Colors.black, // Fond des écrans
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Texte principal
          titleLarge: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ), // Titres accentués
        ),
      ),
      home: const RegistrationPage(), // Page de démarrage
    );
  }
}
