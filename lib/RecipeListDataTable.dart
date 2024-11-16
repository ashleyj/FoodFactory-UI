import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/RecipeModel.dart';

class RecipeListDataTable extends StatefulWidget {
  const RecipeListDataTable({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeListDataTableState();
}

class _RecipeListDataTableState extends State<RecipeListDataTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var recipeList = context.watch<RecipeModel>();

    return SingleChildScrollView(
        child: DataTable(
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
            rows: recipeList.recipes
                .map((recipe) => DataRow(cells: <DataCell>[
                      DataCell(Text(recipe.title)),
                      DataCell(Text(recipe.description))
                    ]))
                .toList()));
  }
}

