class TodoItemAdd {
  final String title;
  final String? description;

  TodoItemAdd({
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'titre':  title.isEmpty ? null : title,
      'description': description,
    };
  }
}
