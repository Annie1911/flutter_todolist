import 'package:flutter/material.dart';
import '../models/TodoItem.dart';
import '../models/TodoItemAdd.dart';
import '../services/authentication_service.dart';
import '../services/todo_service.dart';
import '../widgets/TodoItem.dart';
import 'login_page.dart';
import 'todoupdate_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<TodoPage> {
  late String accessToken;
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _loadTokenAndData() async {
    final String? token = await getToken('access_token');
    if (token != null) {
      setState(() {
        accessToken = token;
      });
      await _fetchData();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _fetchData() async {
    try {
      if (accessToken.isEmpty) {
        throw Exception('Access token is empty or null');
      }

      final fetchedItems = await TodoService.fetchTodoItems(accessToken);
      setState(() {
        todoItems = fetchedItems;
      });
    } catch (e) {
      print('Failed to fetch todo items: $e');
    }
  }

  Future<void> _addItem(String title, String? description) async {
    try {
      final newItem = await TodoService.createTodoItem(
        accessToken,
        TodoItemAdd(title: title, description: description),
      );
      setState(() {
        todoItems.add(newItem);
      });
    } catch (e) {
      print('Failed to add todo item: $e');
    }
  }

  Future<void> _updateItem(TodoItem updatedItem) async {
    try {
      await TodoService.updateTodoItem(
        accessToken,
        TodoItemAdd(
          title: updatedItem.title,
          description: updatedItem.description,
        ),
        updatedItem.id,
      );
      setState(() {
        final index = todoItems.indexWhere((item) => item.id == updatedItem.id);
        if (index != -1) {
          todoItems[index] = updatedItem;
        }
      });
    } catch (e) {
      print('Failed to update todo item: $e');
    }
  }

  Future<void> _deleteItem(int id) async {
    try {
      await TodoService.deleteTodoItem(accessToken!, id);
      setState(() {
        todoItems.removeWhere((item) => item.id == id);
      });
    } catch (e) {
      print('Failed to delete todo item: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cet élément ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem(id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToEditPage(TodoItem item) async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoPage(
          todoItem: item,
          accessToken: accessToken,
        ),
      ),
    );
    if (updatedItem != null) {
      setState(() {
        final index = todoItems.indexWhere((el) => el.id == updatedItem.id);
        if (index != -1) {
          todoItems[index] = updatedItem;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              logout(context);
            },
          ),
        ],
      ),
      body: todoItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final item = todoItems[index];

                return TodoItemWidget(
                  todoItem: item,
                  onEdit: () => _navigateToEditPage(item),
                  onDelete: () => _showDeleteConfirmationDialog(item.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showAddItemDialog(context);
          if (result != null) {
            await _addItem(result['title']!, result['description']);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }


  Future<Map<String, String>?> _showAddItemDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un élément'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Titre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                Navigator.of(context).pop({
                  'title': titleController.text.trim(),
                  'description': descriptionController.text.trim(),
                });
              },
            ),
          ],
        );
      },
    );
  }
}
