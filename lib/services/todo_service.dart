import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/TodoItem.dart';
import '../models/TodoItemAdd.dart';

const String baseUrl = 'http://127.0.0.1:8000/todoitem'; // Remplacez par votre URL de l'API

class TodoService {
  static Future<List<TodoItem>> fetchTodoItems(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/read-all'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((item) => TodoItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch todo items: ${response.reasonPhrase}');
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

    if (response.statusCode == 200) {
      return TodoItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create todo item ${response.reasonPhrase}');
    }
  }

  static Future<void> updateTodoItem(
      String accessToken, TodoItemAdd todoItem, int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todoItem.toJson()),
    );

    if (response.statusCode != 200) {
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
        'Content-Type': 'application/json ; charset=UTF-8',
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
