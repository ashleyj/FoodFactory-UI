import 'package:food_factory_ui/model/RecipeModel.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;


void main() {
    test('Change notifier fires when api call completes', () async {
      final client = MockClient((_) async =>
          http.Response(
              '[{"title": "test", "name": "test name", "description": "test description"}]',
              200));
      final callback = MockCallback();
      RecipeModel recipeModel = RecipeModel(client);
      recipeModel.addListener(callback);
      await recipeModel.fetchRecipes();
      verify(callback()).called(greaterThan(1));
    });
}

class MockCallback extends Mock {
  call();
}
