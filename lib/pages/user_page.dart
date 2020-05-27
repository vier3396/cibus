import 'package:cibus/services/constants.dart';
import 'package:cibus/widgets/vertical_list_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/services/login/user.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/colors.dart';

const kNoRecipeText =
    'Sharing is caring<3 feel free to upload some of your own recipes';

class UserPage extends StatelessWidget {
  final List<Recipe> recipes;
  final UserData userData;
  UserPage({this.userData, this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        NetworkImage(userData.profilePic ?? kBackupProfilePic),
                    radius: 50.0,
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text(
                          userData.name ?? "Cannot find name",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          userData.description ?? "Cannot find description",
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
                                userId: userData.uid,
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
            recipes.isNotEmpty
                ? VerticalListView(
                    title: "More recipes",
                    recipes: recipes,
                    myOwnUserPage: false,
                  )
                : Text(kNoRecipeText),
            //TODO styla denna
          ],
        ),
      ),
    );
  }

  AlertDialog makeAlertDialog(
      {String userId, DatabaseService database, BuildContext context}) {
    return AlertDialog(
      title: Text('Report'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Do you want to report this user to the CIBUS Police?')
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor: kCoral,
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
            },
            child: Text('Report'))
      ],
    );
  }
}
