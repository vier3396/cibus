import 'package:cibus/services/login/user.dart';
import 'package:cibus/widgets/future_article.dart';
import 'package:cibus/widgets/future_favorites.dart';
import 'package:cibus/widgets/future_recipes_home.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';
import 'package:flutter/material.dart';

const TextStyle hiTextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
);
const Divider homePageDivider = Divider(
  thickness: 2.0,
  color: Colors.black,
);

class HomePage extends StatelessWidget {
  final Stream<UserData> userDataStream;
  final String topArticleID = 'article1';
  final String secondArticleID = 'article2';
  final List<dynamic> topRecipes = [
    'Q2wXfXgAHKI7H3WEhkB6',
    'IzJhqGWLQIzTKPpuSl6T',
    '927OAWKNK5OV6X0jfaFz'
  ];
  final String topRecipesTitle = 'Top rated recipes';
  final List<dynamic> seasonalRecipes = [
    '927OAWKNK5OV6X0jfaFz',
    'C8WSAhjMUP0zvNC4R74m',
    'ICnGCGohlxw61UZfe4eL',
    'IzJhqGWLQIzTKPpuSl6T',
    'KtROyaxNhrfbTtlI3rrI'
  ];
  final seasonalTitle = 'Seasonal recipes';

  HomePage({this.userDataStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              body: ListView(
                children: <Widget>[
                  FutureBuilderArticle(articleID: topArticleID),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hi ${userData.username} !' ?? 'Hi!',
                          style: hiTextStyle,
                        ),
                        homePageDivider,
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  FutureBuilderFavorites(userData: userData),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: RecipesHomePage(
                      recipes: topRecipes,
                      title: topRecipesTitle,
                    ),
                  ),
                  FutureBuilderArticle(articleID: secondArticleID,),
                  RecipesHomePage(
                    recipes: seasonalRecipes,
                    title: seasonalTitle,
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: MySpinKitRipple(),
              ),
            );
          }
        });
  }
}
