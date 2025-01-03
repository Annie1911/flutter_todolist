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
      title: json['titre'],
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
      'titre': title,
      'description': description,
      'date_creation': dateCreation.toIso8601String(),
      'date_modification':
          dateModification?.toIso8601String(), // Utilisation optionnelle
    };
  }
}
