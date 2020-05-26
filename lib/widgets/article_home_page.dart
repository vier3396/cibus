import 'package:cibus/pages/userScreens/article_page.dart';
import 'package:cibus/services/models/article.dart';
import 'package:flutter/material.dart';

class ArticleHomePage extends StatelessWidget {
  final Article article;
  final String heroTag;
  ArticleHomePage({this.article, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ArticlePage(
              article: article,
              hero: article.articleID,
            );
          },
        ));
      },
      child: Hero(
        tag: heroTag,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                child: Image(
                  image: NetworkImage(article.topImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    article.subTitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                      //fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
