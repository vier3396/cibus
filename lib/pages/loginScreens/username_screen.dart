import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/services/colors.dart';

OutlineInputBorder textInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25.0),
);

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {

  final _formKey = GlobalKey<FormState>();
  String _currentUsername;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        UserData userData = snapshot.data;

        return Theme(
          data: ThemeData(
              primaryColor: Theme.of(context).primaryColor),
          child: Scaffold(
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Text(
                        'Choose your Cibus username',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(
                          border: textInputBorder,
                          labelText: 'Username',
                        ),
                        validator: (val)  {
                          if(val.length < 3)
                            return 'Name must be more than 2 charater';
                          else
                            return null;
                        },
                        onChanged: (val) => setState(() => _currentUsername = val),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        color: kTurquoise,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()) {
                            bool checkUsername = await DatabaseService().isUsernameTaken(username: _currentUsername);
                            await DatabaseService(uid: user.uid).updateUsername(
                              username: _currentUsername ?? userData.username,
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MyPageView()),
                                    (Route<dynamic> route) => false);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );

      }
    );
  }
}
