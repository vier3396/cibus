import 'package:cibus/pages/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/sign_in.dart';
import 'package:cibus/pages/authtest.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:provider/provider.dart';
import 'package:cibus/pages/settings_screen.dart';
import 'package:cibus/main.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user.uid != null) {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;

              return Scaffold(
                body: Container(
                    color: Colors.blue[100],
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.pink,
                          radius: 60.0,
                          backgroundImage: NetworkImage(userData.profilePic) ??
                              AssetImage('assets/blank_profile_picture.png'),
                        ),
                        RaisedButton(
                          color: Colors.orange[600],
                          hoverColor: Colors.orange,
                          child: Text('Sign Out'),
                          onPressed: () {
                            signIn.signOut(context);
                          },
                        ),
                        Text(userData?.name ?? ''),
                        Text(userData?.username ?? ''),
                        Text(userData?.description ?? ''),
                        Text(userData?.age.toString() ?? ''),
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SettingsScreen();
                                },
                              ),
                            );
                          },
                        ),
                        //print(UserData().name),
                      ],
                    ))),
              );
            } else {
              return LoadingScreen();
            }
          });
    } else {
      return LoadingScreen();
    }
  }
}
