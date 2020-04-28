import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/popup.dart';

const topMarginPopupLayout = 0.0;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<bool> _boldButtons = [false, true, false];
  Container wallOfText = yourRecipes();
  int karma;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildProfileHeader(),
            Divider(color: kCibusTextColor),
            SizedBox(height: 40.0),
            buildProfileButtons(),
            SizedBox(height: 20.0),
            wallOfText,
          ],
        ),
      ),
    );
  }

  Container buildProfileButtons() {
    return Container(
      color: kDarkerkBackgroundColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text(
                "Notifications",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[0] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[0] ? wallOfText : notifications();
                setState(() {
                  _boldButtons = [true, false, false];
                });
                // call function to display right kind of text
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text(
                "Your recipes",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[1] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[1] ? wallOfText : yourRecipes();
                setState(() {
                  _boldButtons = [false, true, false];
                });
                // call function to display right kind of text
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text(
                "Favorites",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[2] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[0] ? wallOfText : favorites();
                setState(() {
                  _boldButtons = [false, false, true];
                });
                // call function to display right kind of text
                // wallOfText = Favorites();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container notifications() {
    return Container(
      child: Text("notifications"),
    );
  }

  static Container yourRecipes() {
    return Container(
      child: Text("your recipes"),
    );
  }

  Container favorites() {
    return Container(
      child: Text("favorites"),
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
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Karma points: $karma',
                style: TextStyle(
                ),
              ),
            ],
          ),
          SizedBox(width: 40.0),
          IconButton(
            icon: Image.asset('assets/cogwheel.png'),
            iconSize: 50,
            onPressed: () {
              PopupLayout(top: topMarginPopupLayout).showPopup(context,
                  popupBodySettings(), 'Settings');
            },
          ),
        ],
      ),
    );
  }

  Widget popupBodySettings() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text("Account"),
              ],
            ),
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
