import 'package:flutter/material.dart';
import 'package:independentproject/services/colors.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override

  List<bool> boldButtons = [true, false, false];

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
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          fontWeight: boldButtons[0] ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onPressed: () {
                        setState(() { boldButtons = [true, false, false]; });
                        // call function to display right kind of text
                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Text(
                        "Your recipes",
                        style: TextStyle(
                            fontWeight: boldButtons[1] ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onPressed: () {
                        setState(() { boldButtons = [false, true, false]; });
                        // call function to display right kind of text
                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Text(
                        "Favorites",
                        style: TextStyle(
                            fontWeight: boldButtons[2] ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      onPressed: () {
                        setState(() { boldButtons = [false, false, true]; });
                        // call function to display right kind of text
                      },
                    ),
                  ),
                ],
              ),
            ), // det här är början på en ny metod
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
