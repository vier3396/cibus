import 'package:cibus/pages/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName;
  int _currentAge;
  String _currentDescription;


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream:  DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData) {

    UserData userData = snapshot.data;


    return Scaffold(
      body: Form(
      key: _formKey,
      child: Column(
      children: <Widget>[
      SizedBox(height: 60.0),
      Text(
      'Update your Cibus settings',
      style: TextStyle(fontSize: 18.0),
      ),
      SizedBox(height: 20.0),
      Text('Name'),
      TextFormField(
      initialValue: userData.name,
      decoration: textInputDecoration,
      validator: (val) => val.isEmpty ? 'Please enter a name' : null,
      onChanged: (val) => setState(() => _currentName = val),
      ),
      SizedBox(height: 40.0),

        Text('Age: $_currentAge'),
        Slider(
          value: (_currentAge ?? userData.age).toDouble(),
          activeColor: Colors.brown[_currentAge ?? userData.age],
          inactiveColor: Colors.brown[_currentAge ?? userData.age],
          min: 1,
          max: 90,
          divisions: 90,
          onChanged: (val) => setState(() => _currentAge = val.round()),
        ),
      SizedBox(height: 40.0),
      Text('Description'),
      TextFormField(
      initialValue: userData.description,
      decoration: textInputDecoration,
      validator: (val) => val.isEmpty ? 'Please enter a description' : null,
      onChanged: (val) => setState(() => _currentDescription = val),
      ),
      SizedBox(height: 20.0),
      RaisedButton(
      color: Colors.pink[400],
      child: Text(
      'update',
      style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
      if(_formKey.currentState.validate()) {
      await DatabaseService(uid: user.uid).updateUserData(
      name: _currentName ?? userData.name,
      description: _currentDescription ?? userData.description,
      age: _currentAge ?? userData.age,
      );
      Navigator.pop(context);
      }
      },
      )
      ],
      ),
      ),
    );
    } else {
        return LoadingScreen();
    }

          }
        );
  }
}
