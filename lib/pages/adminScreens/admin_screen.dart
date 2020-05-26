import 'package:cibus/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/colors.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../loading_screen.dart';

/*class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<AdminData>(
        stream: DatabaseService(uid: user.uid).adminData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            AdminData adminData = snapshot.data;
            print('adminData: ' + adminData.role);
            return loading
                ? LoadingScreen()
                : Scaffold(
                    body: Column(
                      children: <Widget>[
                        SafeArea(
                          child: Text(
                            'Welcome Admin! Do admin stuff here',
                            style: TextStyle(fontSize: 60.0),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(height: 400.0, child: new RecipeListAdmin()),
                      ],
                    ),
                    backgroundColor: kCoral,
                  );
          } else {
            print('fanns ingen admindata');
            return Scaffold(
              body: Column(
                children: <Widget>[
                  SafeArea(
                    child: Text(
                      'You do not have admin privileges',
                      style: TextStyle(fontSize: 60.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: kCoral,
                    child: Text(
                      'Go back',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              backgroundColor: kCoral,
            );
          }
        });
  }
}

class RecipeListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Recipes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['title']),
                  subtitle: new Text(document['description']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
*/
