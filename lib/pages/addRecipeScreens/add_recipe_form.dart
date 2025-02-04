import 'package:cibus/pages/cameraScreens/camera_screen.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';
import '../../services/models/recipe.dart';
import '../../widgets/my_text_form_field.dart';
import '../searchRecipeScreens/popup_body_search_ingredients.dart';
import 'recipe_steps.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cibus/widgets/ingredient_tile.dart';
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
      builder: (context,
          recipe,
          child,) {
        return Scaffold(
          resizeToAvoidBottomPadding: false, // solves keyboard problems
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Add a recipe',
            ),
            leading: Container(),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            //When tapping outside form/text input fields, keyboard disappears
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MyTextFormField(
                        maxLength: kRecipeTitleLength,
                        labelText: "Recipe Title",
                        validator: (String title) {
                          if (title.isEmpty) {
                            return 'Enter a Title';
                          } else {
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
                        maxLines: kRecipeDescLines,
                        maxLength: kRecipeDescLength,
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
                                if (Provider
                                    .of<Recipe>(context, listen: false)
                                    .ingredientCount ==
                                    0) {
                                  return 'choose ingredients';
                                }
                                return null;
                              },
                              maxLength: kMaxIngredients,
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
                                            child: PopupBodySearchIngredients()),
                                      ),
                                );
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
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
                            duration: Duration(milliseconds: 500),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: IngredientTile(index: index),
                              ),
                            ),
                          );
                        },
                        itemCount:
                        (Provider
                            .of<Recipe>(context)
                            .ingredientCount),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MyTextFormField(
                        isAmount: true,
                        maxLength: kCookingTimeLength,
                        labelText: "Total cooking time in minutes",
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
                    picture(recipe),
                    //Submit form button
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: RaisedButton(
                          color: kCoral,
                          splashColor: kWarmOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Review and submit recipe',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              print(recipe.listOfSteps);
                              formKey.currentState.save();
                              final popProvider =
                              Provider.of<Recipe>(context, listen: false);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
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

  Widget picture(Recipe recipe) {
    //print('recipe.imageURL = ${recipe.imageURL}');
    if (recipe.imageURL == null) {
      return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.grey[300],
              child: InkWell(
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black,
                  size: 30.0,
                ),
                onTap: () {
                  final recipeProvider =
                  Provider.of<Recipe>(context, listen: false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: recipeProvider,
                          child: ImageCapture(
                            recipePhoto: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Upload a picture of your dish',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
        child: Stack(
          children: <Widget>[
            Image(
              image: NetworkImage(recipe.imageURL ?? kDefaultProfilePic),
              height: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 5.0,
              right: 5.0, //MediaQuery.of(context).size.width / 3.5,
              child: InkWell(
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.grey[300],
                  child: InkWell(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onTap: () {
                      final recipeProvider =
                      Provider.of<Recipe>(context, listen: false);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ChangeNotifierProvider.value(
                              value: recipeProvider,
                              child: ImageCapture(
                                recipePhoto: true,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                onTap: () {
                  final recipeProvider =
                  Provider.of<Recipe>(context, listen: false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: recipeProvider,
                          child: ImageCapture(
                            recipePhoto: true,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    }
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
}
