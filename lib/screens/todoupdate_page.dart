import 'package:flutter/material.dart';
import '../models/TodoItem.dart';
import '../models/TodoItemAdd.dart';
import '../services/todo_service.dart';

class EditTodoPage extends StatefulWidget {
  final TodoItem todoItem;
  final String accessToken;

  const EditTodoPage(
      {super.key, required this.todoItem, required this.accessToken});

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptioncontroller;
  late String accessToken;

  @override
  void initState() {
    super.initState();
    accessToken = widget.accessToken;
    // Initialisation de accessToken
    _titleController = TextEditingController(text: widget.todoItem.title);
    _descriptioncontroller =
        TextEditingController(text: widget.todoItem.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    try {
      await TodoService.updateTodoItem(
        accessToken,
        TodoItemAdd(
          title: _titleController.text.trim(),
          description: _descriptioncontroller.text.trim(),
        ),
        widget.todoItem.id,
      );

      // Après la mise à jour réussie, retourner à l'écran précédent
      final updatedItem =
          await TodoService.fetchTodoItem(accessToken, widget.todoItem.id);
      Navigator.of(context).pop(updatedItem);
    } catch (e) {
      print('Failed to update todo item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black45, // Changer ici pour une couleur plus visible
        );
    ;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              style: textStyle, // Application du style personnalisé ici
            ),
            TextField(
              controller: _descriptioncontroller,
              decoration: const InputDecoration(labelText: 'Description'),
              style: textStyle, // Application du style personnalisé ici
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateItem,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
