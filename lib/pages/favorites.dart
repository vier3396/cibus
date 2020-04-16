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
        body: Center(
          child: Text('These are your favorites'),
        ),
      ),
    );
  }
}
