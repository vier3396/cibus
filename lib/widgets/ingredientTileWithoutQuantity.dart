import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/ingredientList.dart';

//TODO ändra så att ingredientTile går att använda för båda istället för att ha två

class IngredientTileWithoutQuantity extends StatelessWidget {
  final int index;
  final double width = 50.0;

  IngredientTileWithoutQuantity({this.index});

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
          Text(Provider.of<IngredientList>(context)
              .ingredientList[index]
              .ingredientName),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Provider.of<IngredientList>(context).removeIngredient(index);
              })
        ],
      ),
    );
  }
}
