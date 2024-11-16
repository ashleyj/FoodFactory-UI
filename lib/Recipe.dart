import 'dart:convert';

class Recipe {
  final String title;
  final String name;
  final String description;

  const Recipe({
    required this.title,
    required this.name,
    required this.description
  });

  Recipe.createNew(this.title,
      this.name,
      this.description);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return switch(json) {
      {
      'title': String title,
      'name': String name,
      'description': String description
      } =>
          Recipe(
              title: title,
              name: name,
              description: description
          ),
      _ => throw const FormatException("Failed to process Recipe data"),
    };
  }

  Map<String, dynamic> toJson() => {
      'title': title,
      'name': name,
      'description': description
    };
}
