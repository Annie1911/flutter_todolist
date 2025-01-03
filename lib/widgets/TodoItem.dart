import 'package:flutter/material.dart';
import '../models/TodoItem.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItemWidget({
    Key? key,
    required this.todoItem,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(todoItem.title),
        subtitle:
            todoItem.description != null ? Text(todoItem.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
