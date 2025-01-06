import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
export 'authentication_service.dart';
import '../screens/login_page.dart';
import '../screens/todo_page.dart';

const String prodBaseUrl = 'fastapitodolist-production.up.railway.app/users';

const String devBaseUrl = 'http://192.168.43.49:8000/users';

Future<void> login(
    String username, String password, BuildContext context) async {
  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
    return;
  }

  final url = Uri.parse('$devBaseUrl/login');
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username.trim(),
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('access_token') &&
          responseData['access_token'] != null &&
          responseData['access_token'] is String) {
        final String access_token = responseData['access_token'];
        await saveToken(access_token,
            'access_token'); // Sauvegarde du token dans SharedPreferences
        if (responseData.containsKey('refresh_token') &&
            responseData['refresh_token'] != null &&
            responseData['refresh_token'] is String) {
          final String refresh_token = responseData['refresh_token'];
          await saveToken(refresh_token, 'refresh_token');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodoPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Échec de la connexion. Token invalide.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Échec de la connexion. Vérifiez vos informations.')),
      );
    }
  } catch (e) {
    print('Erreur: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
    );
  }
}

Future<void> refreshToken(String token) async {
  final url = Uri.parse('$devBaseUrl/refresh-token');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
          body: jsonEncode(<String, String>{
        'refresh_token': token,
        'token_type': 'bearer',
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String newToken = responseData['access_token'];
      await saveToken(newToken,
          'access_token'); // Mettre à jour le token dans SharedPreferences
    } else {
      print('Failed to refresh token.');
    }
  } catch (e) {
    print('Erreur: $e');
  }
}

Future<void> saveToken(String token, String token_type) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(token_type, token);
}

Future<String?> getToken(String tokenType) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(tokenType);
}

Future<void> removeToken(String tokenType) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(tokenType);
}

Future<void> register(
    String email,
    String username,
    String lastName,
    String firstName,
    String password,
    BuildContext context) async {
  final url = Uri.parse('$devBaseUrl/create');

  if (email.isEmpty ||username.isEmpty ||lastName.isEmpty || firstName.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
    return;
  }



  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

        'email': email.trim(),
        'username': username.trim(),
        'lastname': lastName.trim(),
        'firstname': firstName.trim(),
        'password': password.trim(),

      }),
    );

    if (response.statusCode == 200) {
      await login(username, password, context);
    } else {
      String errorMessage =
          'Échec de l\'inscription. Code: ${response.statusCode}';
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur d\'inscription: ${e.toString()}')),
    );
  }
}

bool isTokenExpired(String token) {
  final String? expirationClaim = getClaimValue(token, 'exp');
  if (expirationClaim == null) {
    throw Exception('Le token ne contient pas de claim "exp".');
  }

  final int expirationTimestamp = int.parse(expirationClaim);
  final DateTime expirationDate =
      DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);

  return DateTime.now().isAfter(expirationDate);
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
    caseSensitive: false,
    multiLine: false,
  );
  return emailRegex.hasMatch(email.trim());
}

Future<void> logout(BuildContext context) async {
  await removeToken('access_token');
  await removeToken('refresh_token');
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}

Map<String, String> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('JWT invalide');
  }
  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final decodedBytes = base64Url.decode(normalized);
  final Map<String, dynamic> decodedMap = jsonDecode(utf8.decode(decodedBytes));

  return decodedMap.map((key, value) => MapEntry(key, value.toString()));
}

String? getClaimValue(String token, String key) {
  final parsedToken = parseJwt(token);
  return parsedToken[key];
}

Future<void> loadTokenState() async {
  final String? token = await getToken('access_token');
  if (token != null) {
    if (isTokenExpired(token)) {
      print('token expired');
      await removeToken('access_token');
      final String? refresh_token = await getToken('refresh_token');
      if (refresh_token != null) {
        if (isTokenExpired(refresh_token)) {
          print('refresh token expired');
        } else {
          await refreshToken(refresh_token);
        }
      } else {
        print('no refresh_token available');
      }
    } else {
      print('token not expired');
    }
  } else {
    print('token not null');
  }
}













