import 'package:cibus/pages/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:validators/validators.dart' as validator;
import 'recipe.dart';
import 'my_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cibus/pages/popup.dart';

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  Recipe recipe = Recipe();
  int currentStep = 1;
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

  Widget decideImageView() {
    if (imageFile == null) {
      return Center(child: Text("No image selected"));
    } else {
      return Image.file(imageFile, width: 400.0, height: 400.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    recipe.listOfSteps = List(20);

    // works for different screens
    // final halfMedianWidth = MediaQuery.of(context).size.width / 2.0;

    return Form(
      key: _formKey,
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
                  _formKey.currentState.save();
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
                  _formKey.currentState.save();
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
                      //.showPopup(context, popupBody(), 'Add Ingredient');
                    },
                    //TODO:  onSaved: save ingredients to recipe object
                    //TODO: validator: validate ingredients
                  ),
                ),
              ],
            ),
          ),
          //Steps
          Column(
            children: <Widget>[
              ...addRecipeSteps(context),
            ],
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
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    PopupLayout().showPopup(context,
                        popupBodyRecipeResults(), 'Review Your Recipe');
                  }
                }),
          ),
        ],
      ),
    );
  }

//method that returns a list of MyTextFormField and RaisedButton to add recipe steps
  List<Widget> addRecipeSteps(context) {
    List<Widget> listOfTextFormFieldsSteps = [];

    for (int i = 1; i <= currentStep; i++)
      listOfTextFormFieldsSteps.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyTextFormField(
          labelText: "Step $i",
          validator: (String step) {
            if (step.isEmpty) {
              return 'Enter a step';
            } else {
              _formKey.currentState.save();
              return null;
            }
          },
          onSaved: (String step) {
            recipe.listOfSteps[i - 1] = step;
          },
        ),
      ));

    listOfTextFormFieldsSteps.add(
      Center(
        child: RaisedButton(
          child: Text("Add step"),
          onPressed: () {
            setState(() {
              currentStep++;
            });
          },
        ),
      ),
    );

    return listOfTextFormFieldsSteps;
  }

  Widget popupBodySearchIngredients() {
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

  Widget popupBodyRecipeResults() {
    return Container(
      child: ListView(
        children: <Widget>[
          Text("Title"),
          Text(recipe.title != null ? recipe.title : "null"),
          Text("Description"),
          Text(recipe.description != null ? recipe.description : "null"),
          Text("Ingredients"),
          Text("recipe.ingredients"),
          Text("Steps"),
          //Text(recipe.listOfSteps[0]),
          getTextWidgets(recipe.listOfSteps),
          FloatingActionButton(
            child: Text("submit"),
            onPressed: () {
              print("success");
              _formKey.currentState.reset();
              currentStep = 1;
              Navigator.pop(context);
              //recipe = Recipe();
              //TODO send the recuoe to backend nerds
            },
          ),

        ],
      ),
    );
  }

  Widget getTextWidgets(List<dynamic> strings) //services
  {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < strings.length; i++){
      if(strings[i] != null) {
        list.add(new Text(strings[i]));
      }
    }
    return Column(children: list);
  }

}
