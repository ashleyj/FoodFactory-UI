import 'package:flutter/material.dart';

import 'Recipe.dart';

void main() {
  runApp(const MyApp());
}

class RecipeModel with ChangeNotifier {
  final List<Recipe> _recipes = [
    Recipe("Lasagne", "Award Winning Traditional Lasagne"),
    Recipe("Steak & Veg", "Simple, but Delicious, Steak and Veg"),
  ];

  List<Recipe> get recipes => _recipes;

  void add(String title, String description) {
    _recipes.add(Recipe(title, description));
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Recipe Management'),
    );
  }
}

class RecipeListDataTable extends StatelessWidget {
  const RecipeListDataTable({super.key, required this.recipeValueNotifier});
  final RecipeModel recipeValueNotifier;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ListenableBuilder(
            listenable: recipeValueNotifier,
            builder: (BuildContext context, Widget? child) {
              return DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Title",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Description",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )))
                  ],
                  rows: recipeValueNotifier.recipes
                      .map((recipe) => DataRow(cells: <DataCell>[
                            DataCell(Text(recipe.title)),
                            DataCell(Text(recipe.description))
                          ]))
                      .toList());
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RecipeModel recipeModel = RecipeModel();

  void _showFullScreenDialog() {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Add New Recipe'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Center(
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter a valid value";
                                }
                                return null;
                              },
                              controller: titleController,
                              decoration:
                                  const InputDecoration(labelText: "Title"),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter a valid value";
                                }
                                return null;
                              },
                              controller: descriptionController,
                              decoration: (const InputDecoration(
                                  labelText: "Description")),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        recipeModel.add(titleController.text,
                                            descriptionController.text);
                                        Navigator.of(context).pop("OK");
                                      }
                                    },
                                    child: const Text("Submit")))
                          ]))));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: RecipeListDataTable(recipeValueNotifier: recipeModel),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFullScreenDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
