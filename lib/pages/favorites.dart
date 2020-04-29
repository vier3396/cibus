import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

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
