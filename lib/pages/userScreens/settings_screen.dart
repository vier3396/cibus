import 'package:cibus/pages/cameraScreens/camera_screen.dart';
import 'package:cibus/pages/loadingScreens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/models/user.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:cibus/widgets/to_fix_provider_in_popup_recipe.dart';
import 'package:cibus/services/login/auth.dart';

import '../loginScreens/login_screen.dart';

OutlineInputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
);

OutlineInputBorder focusBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kCoral),
  borderRadius: BorderRadius.circular(25.0),
);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool loading = false;
  bool isAdmin = false;

  final _formKey = GlobalKey<FormState>();
  String _currentName;
  String _currentDescription;
  String image;
  final AuthService _auth = AuthService();

  void checkIfAdmin({
    String userId,
    DatabaseService database,
  }) async {
    isAdmin = await database.checkIfAdmin(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);

    setState(() {
      checkIfAdmin(
        userId: user.uid,
        database: database,
      );
    });

    return loading
        ? LoadingScreen()
        : StreamBuilder<UserData>(
            stream: database.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                return Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Text('Settings'),
                    centerTitle: true,
                  ),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }, //When tapping outside form/text input fields, keyboard disappears
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      radius: 70.0,
                                      backgroundImage: NetworkImage(
                                          userData.profilePic ??
                                              kDefaultProfilePic),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 8.0,
                                      left: 8.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.grey[300],
                                      )),
                                ],
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
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 20),
                                child: Center(
                                    child: Text(userData.username,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600))),
                              ),
                              TextFormField(
                                initialValue:
                                    userData.name ?? "Cannot find name",
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  focusedBorder: focusBorder,
                                  border: border,
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Please enter a name' : null,
                                onChanged: (val) =>
                                    setState(() => _currentName = val),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                initialValue: userData.description ??
                                    "Cannot find description",
                                maxLength: 200,
                                minLines: 5,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  focusedBorder: focusBorder,
                                  border: border,
                                ),
                                cursorColor: kCoral,
                                validator: (val) => val.isEmpty
                                    ? 'Please enter a description'
                                    : null,
                                onChanged: (val) =>
                                    setState(() => _currentDescription = val),
                              ),
                              SizedBox(height: 20.0),
                              Center(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: kButtonPadding,
                                      child: RaisedButton(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 50),
                                          child: Text(
                                            'Update',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            await DatabaseService(uid: user.uid)
                                                .updateUserData(
                                              name:
                                                  _currentName ?? userData.name,
                                              description:
                                                  _currentDescription ??
                                                      userData.description,
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                        color: kCoral,
                                        splashColor: kWarmOrange,
                                        shape: kButtonShape,
                                      ),
                                    ),
                                    Padding(
                                      padding: kButtonPadding,
                                      child: RaisedButton(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Log out',
                                            style: TextStyle(fontSize: 15.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return logOutAlert(
                                                    context: context);
                                              });
                                        },
                                        color: Colors.grey[300],
                                        splashColor: kWarmOrange,
                                        shape: kButtonShape,
                                      ),
                                    ),
                                    isAdmin
                                        ? RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return WidgetToFixProvider(
                                                      admin: true,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: Text('Admin page'),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingScreen();
              }
            });
  }

  AlertDialog logOutAlert({BuildContext context}) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text('Do you want to log out from CIBUS?')],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.black,
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
            textColor: kCoral,
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
              setState(() {
                loading = true;
              });
            },
            child: Text('Log out'))
      ],
    );
  }
}
