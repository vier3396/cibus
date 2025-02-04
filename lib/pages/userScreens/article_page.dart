import 'package:cibus/widgets/navigate_back_button.dart';
import 'package:cibus/services/models/article.dart';
import 'package:flutter/material.dart';

const BoxShadow boxShadowHero = BoxShadow(
  color: Colors.black26,
  offset: Offset(0.0, 2.0),
  blurRadius: 6.0,
);

class ArticlePage extends StatelessWidget {
  final Article article;
  final String heroTag;
  ArticlePage({this.article, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    boxShadowHero,
                  ],
                ),
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    child: Image(
                      image: NetworkImage(article.topImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20.0,
                child: NavigateBackButton(),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                if (article.subTitle != null) Text(
                  article.subTitle,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                if (article.description != null) Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Divider(
                    thickness: 2.0,
                    color: Colors.black,
                  ),
                ),
                if (article.articleID == 'article1') Text(
                  'How to',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Column(
                  children: <Widget>[
                    for (var step in article.steps)
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                        child: Text(
                          step,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      )
                  ],
                ),
                if (article.ending != null) Text(article.ending,
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    article.greeting,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (article.bottomImage != null) Container(
            height: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ClipRRect(
              child: Image(
                image: NetworkImage(article.bottomImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
