import 'package:cibus/pages/popup_add_ingredient.dart';
import 'package:cibus/services/popup_content_add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:validators/validators.dart' as validator;
import 'recipe.dart';
import 'my_text_form_field.dart';
import 'add_recipe_form_steps.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final formKey = GlobalKey<FormState>();
  Recipe recipe = Recipe();

  int step = 1;

  File imageFile;

  void openGallery(BuildContext context, Recipe recipe) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      recipe.imageFile = imageFile;
    });
    Navigator.of(context).pop();
  }

  void openCamera(BuildContext context, Recipe recipe) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      recipe.imageFile = imageFile;
    });
    Navigator.of(context).pop();
  }

  Future<void> showChoiceDialog(BuildContext context, Recipe recipe) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("From"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Row(children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    openGallery(context, recipe);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    openCamera(context, recipe);
                  },
                ),
              ],
              ),
            ],
          ),
        ),
      );
    }
    );
  }

  Widget decideImageView () {
    if (imageFile == null) {
      return Center(child: Text("No image selected"));
    }
    else {
      return Image.file(imageFile, width: 400.0, height: 400.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    // works for different screens
    // final halfMedianWidth = MediaQuery.of(context).size.width / 2.0;

    return Form(
      key: formKey,
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
                  formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String title){
                recipe.title = title;
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
                  formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String description){
                recipe.description = description;
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
                    //TODO:  add ingredients to recipe object
                  ),
                ),
              ],
            ),
          ),
          //Steps
          AddRecipeSteps(
            //TODO: want to pass the formkey to AddRecipeSteps class
          ),
          //No image selected/Selected image
          decideImageView(),
          //Add image button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: RaisedButton(
                child: Icon(Icons.add_a_photo),
                onPressed: () {
                  showChoiceDialog(context, recipe);
                },
              ),
            ),
          ),
          //Submit form button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                child: Text("Submit"),
              onPressed: () {
                if (formKey.currentState.validate()) {
                }
              }
            ),
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




