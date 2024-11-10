import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import 'Recipe.dart';

void main() async {
  runApp(const MyApp());
}

Future<List<Recipe>> fetchRecipes() async {
  String uri = const String.fromEnvironment("API_URI");
  final response =
      await http.get(Uri.parse("${uri}/recipes"));
  if (response.statusCode == 200) {
    final List<dynamic> jsonArray = jsonDecode(response.body);
    final List<Recipe> recipeList = List.from(
        jsonArray.map<Recipe>((dynamic recipe) => Recipe.fromJson(recipe)));
    return recipeList;
  } else {
    throw Exception("Failed to get recipes");
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

class RecipeListDataTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecipeListDataTableState();
}

class _RecipeListDataTableState extends State<RecipeListDataTable> {
  late Future<List<Recipe>> futureRecipeList;

  @override
  void initState() {
    super.initState();
    futureRecipeList = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FutureBuilder<List<Recipe>>(
            future: futureRecipeList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                    rows: snapshot.requireData
                        .map((recipe) => DataRow(cells: <DataCell>[
                              DataCell(Text(recipe.title)),
                              DataCell(Text(recipe.description))
                            ]))
                        .toList());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showFullScreenDialog() {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final nameController = TextEditingController();
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
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: "Name"),
                            ),
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
        child: RecipeListDataTable(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFullScreenDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
