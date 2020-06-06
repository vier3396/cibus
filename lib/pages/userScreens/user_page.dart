import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/vertical_list_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/recipe.dart';
import 'file:///C:/cibus/lib/services/models/user.dart';
import 'package:cibus/services/database/database.dart';

const kNoRecipeText =
    'Sharing is caring<3 feel free to upload some of your own recipes';

class UserPage extends StatefulWidget {
  final List<Recipe> recipes;
  final UserData userData;
  UserPage({this.userData, this.recipes});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.userData.profilePic ?? kDefaultProfilePic),
                    radius: 50.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text(
                          widget.userData.name ?? "Cannot find name",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          widget.userData.description ?? "Cannot find description",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Ink(
                          child: Text(
                        'Report Abuse',
                        style: TextStyle(
                          color: kCoral,
                        ),
                      )),
                      onTap: () {
                        DatabaseService database = DatabaseService();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return makeAlertDialog(
                                userId: widget.userData.uid,
                                context: context,
                                database: database);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            widget.recipes.isNotEmpty
                ? VerticalListView(
                    title: "More recipes",
                    recipes: widget.recipes,
                    myOwnUserPage: false,
                    myFavorites: false,
                  )
                : Text(kNoRecipeText),
          ],
        ),
      ),
    );
  }

  AlertDialog makeAlertDialog(
      {String userId, DatabaseService database, BuildContext context}) {
    return AlertDialog(
      title: Text('Report abuse'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Do you want to report this user?')
          ],
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
              database.reportUser(userId: userId);
              Navigator.of(context).pop();
              _displaySnackBar(context);
            },
            child: Text('Report'))
      ],
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: kCoral,
      content: Text("User reported. The CIBUS admins will have a look!"),
      duration: Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
