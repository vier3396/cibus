import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';

class IngredientChooserTile extends StatelessWidget {
  final String ingredientName;
  final String ingredientId;
  final List<String> quantityTypeList = ['gram', 'kg', 'liters'];

  IngredientChooserTile({this.ingredientName, this.ingredientId});

  @override
  Widget build(BuildContext context) {
    int quantityValue;
    String dropDownValue = 'kg';
    return Hero(
      tag: 'ingredient',
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.bounceIn,
        padding: EdgeInsets.all(20.0),
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
            Text(
              ingredientName,
              style: TextStyle(fontSize: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: 'Quantitiy',
                    ),
                    onChanged: (String newValue) {
                      quantityValue = int.parse(newValue);
                    },
                  ),
                ),
                SizedBox(width: 30.0),
                Expanded(
                  child: DropdownButton<String>(
                    onChanged: (String newValue) {
                      dropDownValue = newValue;
                    },
                    items: quantityTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: dropDownValue,
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    elevation: 5.0,
                    color: kCoral,
                    borderRadius: BorderRadius.circular(30.0),
                    child: MaterialButton(
                      onPressed: () {
                        if (quantityValue != null && dropDownValue != null) {
                          Provider.of<Recipe>(context).addIngredient(
                            ingredientName: ingredientName,
                            ingredientId: ingredientId,
                            quantityType: dropDownValue,
                            ingredientQuantity: quantityValue,
                          );
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
