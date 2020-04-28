import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Favorites'),
          ),
        ),
        body: ListView(children: <Widget>[
          Column(children: <Widget>[
            Text("A recipe"),
            Text("Another recipe"),
          ],
          ),
        ],
        ),
      ),
    );
  }
}
