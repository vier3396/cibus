import 'package:cibus/services/article.dart';
import 'package:cibus/services/database.dart';
import 'package:flutter/material.dart';

import 'article_home_page.dart';

class FutureBuilderArticle extends StatelessWidget {
  FutureBuilderArticle({@required this.articleID});
  final String articleID;

  Future<Article> getArticle() async {
    return await DatabaseService().findArticle(articleID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getArticle(),
        builder: (context, futureSnapshot) {
          if (futureSnapshot.hasError)
            return Text('Error: ${futureSnapshot.error}');
          switch (futureSnapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (futureSnapshot.hasData) {
                Article article = futureSnapshot.data;
                return ArticleHomePage(
                  article: article,
                  heroTag: articleID,
                );
              } else {
                return Text(
                    'Something went wrong'); //TODO welcome to cibus picture
              }
          }
          return Text('There\'s no available data.');
        });
  }
}
