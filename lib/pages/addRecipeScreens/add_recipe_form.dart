import 'package:cibus/pages/cameraScreens/camera_screen.dart';
import 'package:cibus/services/camera/uploader.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/popup_layout.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';
import '../../services/models/recipe.dart';
import '../../services/models/my_text_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/models/popup_body_search_ingredients.dart';
import 'recipe_steps.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/widgets/ingredient_tile.dart';
import 'dart:convert';
import '../cameraScreens/camera_screen.dart';

class AddRecipeForm extends StatefulWidget {
  @override
  _AddRecipeFormState createState() => _AddRecipeFormState();
}

class _AddRecipeFormState extends State<AddRecipeForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<Recipe>(
      builder: (
        context,
        recipe,
        child,
      ) {
        return Scaffold(
          resizeToAvoidBottomPadding: false, // solves keyboard problems
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.color,
            elevation: Theme.of(context).appBarTheme.elevation,
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
              child: SingleChildScrollView(
                child: Column(
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
                            // formKey.currentState.save();
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
                        maxLength: 400,
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
                              validator: (String ingredients) {
                                if (Provider.of<Recipe>(context, listen: false)
                                        .ingredientCount ==
                                    0) {
                                  return 'choose ingredients';
                                }
                                return null;
                              },
                              maxLength: 20,
                              labelText: 'Add ingredient',
                              onTap: () {
                                final popProvider =
                                    Provider.of<Recipe>(context, listen: false);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      ChangeNotifierProvider.value(
                                    value: popProvider,
                                    child: SingleChildScrollView(
                                      child: PopupBodySearchIngredients(),
                                    ),
                                  ),
                                );
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },

                              //TODO:  onSaved: save ingredients to recipe object
                              //TODO: validator: validate ingredients
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimationLimiter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 3,
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: IngredientTile(index: index),
                              ),
                            ),
                          );
                        },
                        itemCount:
                            (Provider.of<Recipe>(context).ingredientCount),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MyTextFormField(
                        isAmount: true,
                        maxLength: 10,
                        labelText: "How many minutes does the recipe take?",
                        validator: (String time) {
                          if (time.isEmpty) {
                            return 'Enter a time';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (String time) {
                          recipe.addTime(int.parse(time));
                        },
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
                            final popProvider =
                                Provider.of<Recipe>(context, listen: false);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider.value(
                                    value: popProvider,
                                    child: ImageCapture(
                                      recipePhoto: true,
                                    ),
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

                              final popProvider =
                                  Provider.of<Recipe>(context, listen: false);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    //TODO fixa navigator till något bättre?
                                    return ChangeNotifierProvider.value(
                                      value: popProvider,
                                      child: RecipePreview(
                                        preview: true,
                                      ),
                                    );
                                  },
                                ),
                              );
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

//final popProvider =
//                                    Provider.of<Recipe>(context);
//                                showModalBottomSheet(
//                                  isScrollControlled: true,
//                                  context: context,
//                                  builder: (context) =>
//                                      ChangeNotifierProvider.value(
//                                    value: popProvider,
//                                    child: SingleChildScrollView(
//                                      child: popupBodyRecipeResults(),
//                                      padding: EdgeInsets.only(
//                                        bottom: MediaQuery.of(context)
//                                            .viewInsets
//                                            .bottom,
//                                      ),
//                                    ),
//                                  ),
//                                );
