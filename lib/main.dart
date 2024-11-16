import 'package:flutter/material.dart';
import 'package:food_factory_ui/model/RecipeModel.dart';
import 'package:food_factory_ui/RecipeListDataTable.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecipeModel>(create: (context) => RecipeModel())
      ],
      child: MaterialApp(
        title: 'Recipe Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Recipe Management'),
      ),
    );
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
    var recipeList = Provider.of<RecipeModel>(context, listen: false);

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
                                        recipeList.addRecipe(
                                            titleController.text,
                                            nameController.text,
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
      body: const Center(child: RecipeListDataTable()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFullScreenDialog();
        },
        tooltip: 'New Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}
