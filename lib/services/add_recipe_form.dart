import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:validators/validators.dart' as validator;
import 'recipe_form_data.dart';


class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  RecipeFormData recipeFormData = RecipeFormData();

  @override
  Widget build(BuildContext context) {
    final halfMedianWidth = MediaQuery.of(context).size.width / 2.0; //olika stora skärmar

    return Form(
      key: _formKey,
      child: ListView(
        //padding: EdgeInsets.all(10.0),
        children: <Widget>[
          //Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextFormField(
              maxLength: 50,
              labelText: "Recipe Title",
              validator: (String title) {
                if (title.isEmpty) {
                  return 'Enter a Title';
                }
                else {
                  _formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String title){
                recipeFormData.title = title;
              },
            ),
          ),
          //Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextFormField(
              maxLines: 5,
              labelText: "Describe your dish",
              validator: (String description) {
                if (description.isEmpty) {
                  return 'Enter a Description';
                }
                else {
                  _formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String description){
                recipeFormData.description = description;
              },
            ),
          ),
          //Ingredients
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget> [
                MyTextFormField(
                  maxLength: 20,
                  labelText: "Ingredient",
                ),
                Text("QT"),
                MyTextFormField(
                  maxLength: 6,
                  labelText: "amount",
                ),
              ],
            ),
          ),
          MyTextFormField(),
          //TODO: Add picture
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {

              }
            }
          ),
        ],
      ),
    );
  }
}


class MyTextFormField extends StatelessWidget {
  final String labelText;
  final Function validator;
  final Function onSaved;
  final int maxLines;
  final int maxLength;

  MyTextFormField({
    this.labelText,
    this.validator,
    this.onSaved,
    this.maxLines = 1,
    this.maxLength = 30,
});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}
