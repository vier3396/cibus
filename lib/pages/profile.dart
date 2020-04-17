import 'package:flutter/material.dart';
import 'package:independentproject/services/colors.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<bool> _boldButtons = [false, true, false];

  int _currentOption = 1;
  List<Widget> _profileOptions = [
    MyRecipes(),
    MyNotification(),
    MyFavorites()
  ];

  void onPressed () {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildProfileHeader(),
            Divider(color: cibusTextColor),
            SizedBox(height: 40.0),
            Container(
              color: darkerBackgroundColor,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton(
                        child: Center(
                            child: Text('Your recipes',
                            style: TextStyle(
                              fontWeight: _boldButtons[0] ? FontWeight.bold : FontWeight.normal,
                            ),
                            ),
                        ),
                        onPressed: (){
                          print('your recipes pressed');
                          setState(() {
                            _boldButtons = [true, false, false];
                          });
                        },
                      ),
                  ),
                  Expanded(
                      child: FlatButton(
                        child: Center(
                          child: Text('Notifictions',
                            style: TextStyle(
                              fontWeight: _boldButtons[1] ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ),
                        onPressed: (){
                          print('notifications pressed');
                          setState(() {
                            _boldButtons = [false, true, false];
                          });
                        },
                      ),
                  ),
                  Expanded(
                      child: FlatButton(
                        child: Center(
                          child: Text('Favorite recipes',
                          style: TextStyle(
                            fontWeight: _boldButtons[2] ? FontWeight.bold : FontWeight.normal,
                          ),
                          ),
                        ),
                        onPressed: (){
                          print('favorites pressed');
                          setState(() {
                            _boldButtons = [false, false, true];
                          });
                        },
                      ),
                  ),
              ],
              ),
            ), // det här ä början på en ny metod
          ],
        ),
      ),
    );
  }

  Padding buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/blank_profile_picture.png'),
            radius: 40.0,
          ),
          SizedBox(width: 20.0),
          Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'YOUR NAME',
                style: TextStyle(
                  color: cibusTextColor,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Karma points',
                style: TextStyle(
                  color: cibusTextColor,
                ),
              ),
            ],
          ),
          SizedBox(width: 40.0),
          IconButton(
            icon: Image.asset('assets/cogwheel.png'),
            iconSize: 50,
            onPressed: () {
              print("pressed!"); // push settings!
            },
          ),
        ],
      ),
    );
  }
}


class MyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

