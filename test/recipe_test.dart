import 'package:food_factory_ui/Recipe.dart';
import 'package:test/test.dart';

void main() {
  test('Recipe should serialise', () {
    Recipe recipe = Recipe.createNew("title", "name", "description");
    expect(recipe.toJson(), {
      'title': 'title',
      'name': 'name',
      'description': 'description'
    });
  });

  test('Recipe should deserialise', () {
    Recipe recipe = Recipe.fromJson({
      'title': 'title',
      'name': 'name',
      'description': 'description'
    });
    expect(recipe.title, 'title');
    expect(recipe.name, 'name');
    expect(recipe.description, 'description');
  });

  test('Invalid recipe deserialisation should throw exception', () {
    expect(() => Recipe.fromJson({
      'invalid-content': 'invalid-value',
    }), throwsA(isA<FormatException>()));
  });
}
