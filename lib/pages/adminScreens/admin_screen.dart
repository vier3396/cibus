import 'package:cibus/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/colors.dart';
import 'package:firebase_admin/firebase_admin.dart';

import '../loading_screen.dart';

class AdminScreen extends StatefulWidget {
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
            if (adminData.role == 'admin') {
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
                        ],
                      ),
                    );
            } else {
              print('adminData_ ' + adminData.role);
              return Scaffold(
                body: Column(
                  children: <Widget>[
                    SafeArea(
                      child: Text(
                        'You do not have admin privileges',
                        style: TextStyle(fontSize: 60.0),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            print('fanns ingen admindata');
            return Scaffold(
              body: Column(
                children: <Widget>[
                  SafeArea(
                    child: Text(
                      'You do not have admin privileges',
                      style: TextStyle(fontSize: 60.0),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Future<void> _notAdminDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not quite yet!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Sorry the servers are still working on your verification, try again! :)'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  loading = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
