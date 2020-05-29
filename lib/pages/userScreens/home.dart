import 'package:cibus/services/login/user.dart';
import 'package:cibus/widgets/future_article.dart';
import 'package:cibus/widgets/future_favorites.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';
import 'package:flutter/material.dart';

const TextStyle hiTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);
const Divider homePageDivider = Divider(
  thickness: 2.0,
  color: Colors.black,
);

class HomePage extends StatelessWidget {
  final Stream<UserData> userDataStream;
  final String topArticleID;
  HomePage({this.userDataStream, this.topArticleID = 'article1'});

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
