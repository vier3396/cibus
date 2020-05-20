import 'package:cibus/services/recipe.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextStyle textStyleTitle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

class VerticalListView extends StatelessWidget {
  final String title;
  final List<Recipe> recipes;

  VerticalListView({this.title, this.recipes});

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
                title,
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
            height: 500.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: recipes.length,
              itemBuilder: (BuildContext context, int index) {
                Recipe currentRecipe = recipes[index];
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
                    //height: 200,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
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
                                      .imageURL ??
                                      'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/images%2F2020-05-08%2011%3A32%3A16.330607.png?alt=media&token=1e4bff1d-c08b-4afa-a1f3-a975e46e89c5'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              //TODO fixa denna knapp
                              /*
                              Positioned(
                                right: 10.0,
                                top: 10.0,
                                child: FavoriteButton(),
                              ),

                               */
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 120.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    currentRecipe.title ??
                                        'Could not find title',
                                    style: textStyleTitle,
                                  ),
                                  Text(
                                    currentRecipe.description ??
                                        'Could not find description',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
}
