import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/firstScreen.dart';


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

        return Scaffold(
          body: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 60.0),
                Text(
                  'Update your Cibus username',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                Text('Name'),
                TextFormField(
                  initialValue: '',
                  decoration: textInputDecoration,
                  validator: (val)  {
                    if(val.length < 3)
                      return 'Name must be more than 2 charater';
                    else
                      return null;
                  },
                  onChanged: (val) => setState(() => _currentUsername = val),
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()) {
                      bool checkUsername = await DatabaseService().isUsernameTaken(username: _currentUsername);
                      await DatabaseService(uid: user.uid).updateUsername(
                        username: _currentUsername ?? userData.username,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return MyPageView();
                            },
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );

      }
    );
  }
}
