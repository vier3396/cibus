import 'package:cibus/pages/popup_add_ingredient.dart';
import 'package:cibus/services/popup_content_add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:validators/validators.dart' as validator;
import 'recipe_form_data.dart';
import 'my_text_form_field.dart';
//import 'upload_image.dart';


class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  RecipeFormData recipeFormData = RecipeFormData();

  void openGallery(){}
  void openCamera(){}

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text("Gallery"),
                onTap: () {
                  openGallery();
                },
              ),
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  openCamera();
                },
              ),
            ],
          ),
        ),
      );
    }
    );
  }


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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Expanded(
                  child: MyTextFormField(
                    maxLength: 20,
                    labelText: "Add ingredient",
                    onTap: () {
                      showPopup(context, _popupBody(), 'Add Ingredient');
                    },
                  ),
                ),
              ],
            ),
          ),
          //Steps
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyTextFormField(
              labelText: "Step 1",
            ),
          ),
          Center(
              child: RaisedButton(
                child: Text("Add step"),
                onPressed: () {
                  //Add new text input field
                },
              ),
          ),
          //TODO: Add picture
          RaisedButton(
            child: Icon(Icons.add_a_photo),
            onPressed: () {
              showChoiceDialog(context);
            },
          ),
          //Submit form
          RaisedButton(
              child: Text("Submit"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
              }
            }
          ),
        ],
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 40,
        left: 0,
        right: 0,
        bottom: 0,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody() {
    return Container(
      child: ListView(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        children: <Widget>[
          MyTextFormField(

            labelText: "Search",
          ),
        ],

      ),
    );
  }

}




