import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl =
    'http://127.0.0.1:8000/todoitem'; // Remplacez par votre URL de l'API

class TodoService {
  static Future<List<TodoItem>> fetchTodoItems(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/read-all'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => TodoItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todo items');
    }
  }

  static Future<TodoItem> createTodoItem(
      String accessToken, TodoItemAdd todoItem) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todoItem.toJson()),
    );

    if (response.statusCode == 201) {
      return TodoItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create todo item');
    }
  }

  static Future<void> updateTodoItem(
      String accessToken, TodoItem todoItem) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/${todoItem.id}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todoItem.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update todo item');
    }
  }

  static Future<void> deleteTodoItem(String accessToken, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo item');
    }
  }

  static Future<TodoItem> fetchTodoItem(String accessToken, int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/read-one/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return TodoItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load todo item');
    }
  }
}

class TodoItem {
  final int id;
  final String title;
  final String? description; // Correspond à "description" en Python
  final DateTime dateCreation; // Correspond à "date_creation"
  final DateTime? dateModification; // Correspond à "date_modification"

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    required this.dateCreation,
    this.dateModification,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateCreation: DateTime.parse(json['date_creation']),
      dateModification: json['date_modification'] != null
          ? DateTime.parse(json['date_modification'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date_creation': dateCreation.toIso8601String(),
      'date_modification':
      dateModification?.toIso8601String(), // Utilisation optionnelle
    };
  }
}

class TodoItemAdd {
  final String title;
  final String? description;

  TodoItemAdd({
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

