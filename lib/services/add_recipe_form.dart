import 'package:cibus/services/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'recipe.dart';
import 'my_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'popup_body_search_ingredients.dart';
import 'steps.dart';

/*

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final formKey = GlobalKey<FormState>();
  Recipe recipe = Recipe();
  File imageFile;

  //Open gallery
  void openGallery(BuildContext context, Recipe recipe) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      recipe.imageFile = imageFile;
    });
    Navigator.of(context).pop();
  }

  //Open camera
  void openCamera(BuildContext context, Recipe recipe) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      recipe.imageFile = imageFile;
    });
    Navigator.of(context).pop();
  }

  //Popup - choose between open gallery or camera
  Future<void> showChoiceDialog(BuildContext context, Recipe recipe) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("From"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Row(
                    children: <Widget>[
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
        });
  }

  //No image selected, or view image selected
  Widget decideImageView() {
    if (imageFile == null) {
      return Center(child: Text("No image selected"));
    } else {
      return Image.file(imageFile, width: 400.0, height: 400.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final halfMedianWidth = MediaQuery.of(context).size.width / 2.0; (for different screens)

    return Form(
      key: formKey,
      child: ListView(
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
                } else {
                  formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String title) {
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
                } else {
                  formKey.currentState.save();
                  return null;
                }
              },
              onSaved: (String description) {
                recipe.description = description;
              },
            ),
          ),
          //Ingredients
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: MyTextFormField(
                    maxLength: 20,
                    labelText: "Add ingredient",
                    onTap: () {
                      PopupLayout().showPopup(context,
                          popupBodySearchIngredients(), 'Add Ingredient');
                    },
                    //TODO:  onSaved: save ingredients to recipe object
                    //TODO: validator: validate ingredients
                  ),
                ),
              ],
            ),
          ),
          RecipeSteps(
            formkey: formKey,
            recipe: recipe,
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
                child: Text("Review and submit recipe"),
                onPressed: () {
                  if (formKey.currentState.validate()  ) {
                    print(recipe.listOfSteps[0]);
                    formKey.currentState.save();
                    //if (isRecipesListNotNull()) {
                    //}
                    PopupLayout().showPopup(context, popupBodyRecipeResults(),
                        'Review Your Recipe');
                  }
                }),
          ),
        ],
      ),
    );
  }

  //Popup page to preview and submit the recipe form
  Widget popupBodyRecipeResults() {
    return Container(
      child: ListView(
        children: <Widget>[
          Text(recipe.title != null ? recipe.title : "null"),
          Text(recipe.description != null ? recipe.description : "null"),
          Text("recipe.ingredients"),
          getTextWidgets(recipe.listOfSteps),
          FloatingActionButton(
            child: Text("Submit"),
            onPressed: () {
              // send it here to avoid overwrite loss
              print("Success");
              formKey.currentState.reset();
              recipe = Recipe();
              recipe.listOfSteps = List(20);
              Navigator.pop(context);
              //TODO send the recipe to the backend nerds
            },
          ),
        ],
      ),
    );
  }

  //Column with recipe steps as strings
  Widget getTextWidgets(List<dynamic> strings) //services
  {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      if (strings[i] != null) {
        list.add(new Text(strings[i]));
      }
    }
    return Column(children: list);
  }

  bool isRecipesListNotNull() { // behövs nog inte
    for (int i = 0; i < recipe.listOfSteps.length; i++ ) {
      if (recipe.listOfSteps[i] != null) {
        return true;
      }
      return false;
    }
  }
}


 */