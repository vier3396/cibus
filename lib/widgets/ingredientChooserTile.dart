import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/recipe.dart';
import 'package:provider/provider.dart';

class IngredientChooserTile extends StatefulWidget {
  final String ingredientName;
  final String ingredientId;

  IngredientChooserTile({this.ingredientName, this.ingredientId});

  @override
  _IngredientChooserTileState createState() => _IngredientChooserTileState();
}

class _IngredientChooserTileState extends State<IngredientChooserTile> {
  int quantityValue;
  TextEditingController quantityValueController;
  final List<String> quantityTypeList = [
    'grams',
    'kilos',
    'liters',
    'deciliters',
    'pieces',
    'cans',
    'dash',
    'teaspoons',
    'tablespoons',
    'cups',
    'cloves',
    'stems',
    'pinches',
    'whole',
    'half',
    'third',
    'quarter',
    'fifth',
  ];

  String dropDownValue = 'kilos';
  @override
  void initState() {
    // TODO: implement initState
    quantityValueController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    quantityValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //String dropDownValue = 'kgs';
    print("dropdownValue i shuno build: $dropDownValue");

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
              widget.ingredientName,
              style: TextStyle(fontSize: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: quantityValueController,
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
                SizedBox(width: 10.0),
                Expanded(
                  child: DropdownButton<String>(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        print("dropDownValue: $dropDownValue");
                        print("newValue: $newValue");
                        dropDownValue = newValue;
                        print("dropDownValue = newValue;");
                        print("newValue: $newValue");
                        print("dropDownValue: $dropDownValue");
                      });
                    },
                    items: quantityTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                    value: dropDownValue,
                  ),
                ),
                SizedBox(
                  width: 10.0,
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
                          Provider.of<Recipe>(context, listen: false)
                              .addIngredient(
                            ingredientName: widget.ingredientName,
                            ingredientId: widget.ingredientId,
                            quantityType: dropDownValue,
                            ingredientQuantity: quantityValue,
                          );
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                        setState(() {
                          // quantityValue = null;
                          dropDownValue = 'kgs';
                          quantityValueController.clear();
                        });
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
