import 'package:cibus/pages/adminScreens/admin_screen.dart';
import 'package:cibus/pages/camera_screen.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/services/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:cibus/services/imageServices.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/widgets/toFixProviderInPopupRecipe.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loginScreens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  //form values
  String _currentName;
  String _currentDescription;
  String image;
  final AuthService _auth = AuthService();
  bool loading = false;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return loading
        ? LoadingScreen()
        : StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Settings'),
                  ),
                  body: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: NetworkImage(
                                      userData.profilePic ?? kBackupProfilePic),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ImageCapture(
                                        recipePhoto: false,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Name',
                          style: TextStyle(
                            color: kCoral,
                          ),
                        ),
                        TextFormField(
                          initialValue: userData.name ?? "Cannot find name",
                          decoration: textInputDecoration,
                          validator: (val) =>
                              val.isEmpty ? 'Please enter a name' : null,
                          onChanged: (val) =>
                              setState(() => _currentName = val),
                        ),
                        SizedBox(height: 40.0),
                        //Text('Description'),
                        TextFormField(
                          initialValue:
                              userData.description ?? "Cannot find description",
                          minLines: 3,
                          maxLines: 20,
                          decoration: textInputDecoration,
                          cursorColor: kCoral,
                          validator: (val) =>
                              val.isEmpty ? 'Please enter a description' : null,
                          onChanged: (val) =>
                              setState(() => _currentDescription = val),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: kCoral,
                          child: Text(
                            'Update',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                name: _currentName ?? userData.name,
                                description:
                                    _currentDescription ?? userData.description,
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  //TODO fixa navigator till något bättre?
                                  return WidgetToFixProvider(
                                    admin: true,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text('Admin page'),
                        ),
                        RaisedButton(
                          child: Text("log out"),
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            _auth.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingScreen();
              }
            });
  }
}
