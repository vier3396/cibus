import 'package:flutter/material.dart';

class SearchRecipe extends StatefulWidget {
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Search recipe'),
          ),
        ),
        body: Center(
          child: Text('Search for recipes'),
        ),
      ),
    );
  }
}
