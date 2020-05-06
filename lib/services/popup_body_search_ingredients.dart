import 'package:cibus/services/recipe.dart';
import 'package:flutter/material.dart';
import 'my_text_form_field.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';

class PopupBodySearchIngredients extends StatefulWidget {
  @override
  _PopupBodySearchIngredientsState createState() =>
      _PopupBodySearchIngredientsState();
}

class _PopupBodySearchIngredientsState
    extends State<PopupBodySearchIngredients> {
  String ingredientName = ' ';
  String ingredientSearch;
  Map ingredientMap = Map();
  String ingredientId = '';
  List<String> quantityTypeList = ['gram', 'kg', 'liters'];
  String dropDownValue = 'kg';
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);

    return ListView(
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      children: <Widget>[
        TextField(
          onChanged: (toSearch) {
            ingredientSearch = toSearch;
            ingredientSearch =
                "${ingredientSearch[0].toUpperCase()}${ingredientSearch.substring(1)}";
            print(ingredientSearch);
          },
        ),
        FlatButton(
            onPressed: () async {
              ingredientMap = await database.getIngredient(ingredientSearch);
              setState(() {
                print(ingredientMap['ingredientName']);
                ingredientName = ingredientMap['ingredientName'];
                ingredientId = ingredientMap['ingredientId'];
              });
            },
            child: Text('Search')),
        Row(
          children: <Widget>[
            Expanded(child: Text(ingredientName)),
            Expanded(
                child: TextField(
              decoration: InputDecoration(hintText: 'Enter quantitiy'),
            )),
            SizedBox(width: 5.0),
            Expanded(
              child: DropdownButton<String>(
                onChanged: (String newValue) {
                  setState(() {
                    dropDownValue = newValue;
                  });
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
            RaisedButton(
                child: Text('Add'),
                onPressed: () {
                  Provider.of<Recipe>(context).addIngredient(
                    ingredientName: ingredientName,
                    ingredientId: ingredientId,
                    quantityType: 'liter',
                    ingredientQuantity: 5,
                  );
                  return null;
                }),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Text(Provider.of<Recipe>(context)
                    .ingredients[index]
                    .ingredientName),
              ],
            );
          },
          itemCount: (Provider.of<Recipe>(context).ingredientCount),
        ),
      ],
    );
  }
}

//Widget popupBodySearchIngredients() {
//  Provider.of<User>(context)
//  String ingredientSearch;
//  return Container(
//    child: ListView(
//      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
//      children: <Widget>[
//        TextField(
//          onChanged: (toSearch) {
//            ingredientSearch = toSearch;
//            print(ingredientSearch);
//          },
//        ),
//        FlatButton(onPressed: (){
//
//        }, child: Text('Search'))
//      ],
//    ),
//  );
//}
