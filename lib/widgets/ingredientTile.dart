import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/recipe.dart';

class IngredientTile extends StatefulWidget {
  final int index;

  IngredientTile({this.index});

  @override
  _IngredientTileState createState() => _IngredientTileState();
}

class _IngredientTileState extends State<IngredientTile> {
  double width = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Text(Provider.of<Recipe>(context)
              .ingredients[widget.index]
              .ingredientName),
          Text(
              '${Provider.of<Recipe>(context).ingredients[widget.index].quantity} ${Provider.of<Recipe>(context).ingredients[widget.index].quantityType}'),
          Expanded(
            child: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  Provider.of<Recipe>(context, listen: false)
                      .removeIngredient(widget.index);
                }),
          )
        ],
      ),
    );
  }
}
