import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../Recipe.dart';

class RecipeModel extends ChangeNotifier {
  String uri = const String.fromEnvironment("API_URI");
  List<Recipe> recipes = [];

  RecipeModel() {
    fetchRecipes();
  }

  void fetchRecipes() async {
    final response = await http.get(Uri.parse("${uri}/recipes"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = jsonDecode(response.body);
      final List<Recipe> recipeList = List.from(
          jsonArray.map<Recipe>((dynamic recipe) => Recipe.fromJson(recipe)));
      recipes = recipeList;
      notifyListeners();
    } else {
      throw Exception("Failed to get recipes");
    }
  }

  Future<Recipe> addRecipe(String title, String name, String description) async {
    final response = await http.post(Uri.parse("$uri/recipes"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            Recipe(title: title, name: name, description: description).toJson()));
    if (response.statusCode == 201) {
      fetchRecipes();
      return Recipe.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
