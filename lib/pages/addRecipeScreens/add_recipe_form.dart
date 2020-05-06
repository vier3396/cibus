import 'package:cibus/pages/camera_screen.dart';
import 'package:cibus/services/camera/uploader.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/popup_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import '../../services/recipe.dart';
import '../../services/my_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/popup_body_search_ingredients.dart';
import 'recipe_steps.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import '../camera_screen.dart';

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final formKey = GlobalKey<FormState>();

  // TODO: use different method for uploading pictures
  /*
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


 */

  @override
  Widget build(BuildContext context) {
    // final halfMedianWidth = MediaQuery.of(context).size.width / 2.0; (for different screens)

    return Consumer<Recipe>(
      builder: (context, recipe, child) {
        return MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomPadding: false, // solves keyboard problems
            appBar: AppBar(
              backgroundColor: kDarkerkBackgroundColor,
              title: Center(
                child: Text(
                  'Add a recipe',
                  style: TextStyle(
                    color: kCibusTextColor,
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              }, //When tapping outside form/text input fields, keyboard disappears
              child: Form(
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
                            //formKey.currentState.save();
                            return null;
                          }
                        },
                        onSaved: (String title) {
                          recipe.addTitle(title);
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
                            //formKey.currentState.save();
                            return null;
                          }
                        },
                        onSaved: (String description) {
                          recipe.addDescription(description);
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
                              labelText: 'Add ingredient',
                              onTap: () {
                                PopupLayout(child: PopupBodySearchIngredients())
                                    .showPopup(
                                        context,
                                        PopupBodySearchIngredients(),
                                        'Add Ingredient');
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
                    // decideImageView(), TODO: different method
                    //Add image button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: RaisedButton(
                          child: Icon(Icons.add_a_photo),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ImageCapture(
                                    recipePhoto: true,
                                  );
                                },
                              ),
                            );
                            // showChoiceDialog(context, recipe); TODO: different method
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
                            if (formKey.currentState.validate()) {
                              print(recipe.listOfSteps);
                              formKey.currentState.save();
                              //if (isRecipesListNotNull()) {
                              //}
                              PopupLayout().showPopup(
                                  context,
                                  popupBodyRecipeResults(),
                                  'Review Your Recipe');
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //Popup page to preview and submit the recipe form
  Widget popupBodyRecipeResults() {
    User user = Provider.of<User>(context);
    return Consumer<Recipe>(builder: (context, recipe, child) {
      return Container(
        child: ListView(
          children: <Widget>[
            Text(recipe.title != null ? recipe.title : "null1"),
            Text(recipe.description != null ? recipe.description : "null"),
            Text(recipe.ingredients[0].ingredientName),
            getTextWidgets(recipe.listOfSteps),
            FloatingActionButton(
              child: Text("Submit"),
              onPressed: () {
                //print(recipe.toMap().toString());
                recipe.addUserId(user.uid);
                DatabaseService(uid: user.uid).uploadRecipe(recipe);
                // send it here to avoid overwrite loss
                print("Success");
                formKey.currentState.reset();
                //recipe.dispose();
                Navigator.pop(context);
                //TODO send the recipe to the backend nerds
              },
            ),
          ],
        ),
      );
    });
  }

  //Column with recipe steps as strings
  Widget getTextWidgets(List<dynamic> strings) //services
  {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < strings.length; i++) {
      if (strings[i] != null) {
        list.add(Text(strings[i]));
      }
    }
    return Column(children: list);
  }

  //bool isRecipesListNotNull() {
//    // behövs nog inte
//    for (int i = 0; i < recipe.listOfSteps.length; i++) {
//      if (recipe.listOfSteps[i] != null) {
//        return true;
//      }
//      return false;
//    }
//  }
}