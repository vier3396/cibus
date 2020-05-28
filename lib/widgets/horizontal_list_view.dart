import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/recipe.dart';
//import 'favorite_button.dart';

TextStyle textStyleTitle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

class HorizontalListView extends StatefulWidget {
  final String title;
  final List<Recipe> recipes;
  final bool myFavorites;

  HorizontalListView({
    this.title,
    this.recipes,
    this.myFavorites,
  });

  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  final DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        ChangeNotifierProvider<Recipe>(
          create: (context) => Recipe(),
          child: Container(
            height: 350.0, //300.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.recipes.length,
              itemBuilder: (BuildContext context, int index) {
                Recipe currentRecipe = widget.recipes[index];
                return GestureDetector(
                  onTap: () {
                    Provider.of<Recipe>(context, listen: false)
                        .addRecipeProperties(currentRecipe);

                    final recipeProvider =
                    Provider.of<Recipe>(context, listen: false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: recipeProvider,
                          child: RecipePreview(
                            preview: false,
                          ),
                        );
                      }),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    width: 210.0,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(
                          //bottom: 15.0,
                          top: 190,
                          child: Container(
                            height: 150.0,//120.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    currentRecipe.title ??
                                        'Could not find title',
                                    style: textStyleTitle,
                                  ),
                                  Expanded(
                                    child: Text(
                                      currentRecipe.description ??
                                          'Could not find description',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  height: 180.0,
                                  width: 180.0,
                                  image: NetworkImage(currentRecipe
                                      .imageURL ?? kDefaultRecipePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                child: widget.myFavorites
                                    ? IconButton(
                                    icon: Icon(Icons.favorite, color: kCoral, size: 30.0,),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return removeFavoriteAlert(
                                              recipeId: widget
                                                  .recipes[index].recipeId,
                                              context: context,
                                              database: database,
                                              index: index,
                                            );
                                          });
                                      //  database.removeRecipe(
                                      //  currentRecipe.recipeId,
                                      //  );
                                    })
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog removeFavoriteAlert({
    String recipeId,
    DatabaseService database,
    BuildContext context,
    int index,
  }) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text('Do you want to remove this recipe from favorites?')],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: kCoral,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            textColor: kCoral,
            onPressed: () {
              database.removeFromUserFavorites(recipeId: recipeId, currentFavorites: widget.recipes);
              Navigator.of(context).pop();
              setState(() {
                widget.recipes.removeAt(index);
              });
            },
            child: Text('Remove'))
      ],
    );
  }


}
