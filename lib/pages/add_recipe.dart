import 'package:flutter/material.dart';


class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('Add a recipe'),
          ),
        ),
        body: Center(
          child: Text('Add a recipe page'),
        ),
      ),
    );
  }
}
