import 'package:flutter/material.dart';
import 'recipe.dart';

class PopupBodyIndividualRecipe extends StatefulWidget {
  PopupBodyIndividualRecipe({
    @required this.recipe,
});

  Recipe recipe;

  @override
  _PopupBodyIndividualRecipeState createState() => _PopupBodyIndividualRecipeState();
}

class _PopupBodyIndividualRecipeState extends State<PopupBodyIndividualRecipe> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Image.asset(widget.recipe.imageFile,
        width: MediaQuery.of(context).size.width,
        //TODO: image size problem
      ),
    ],
    );
  }
}


