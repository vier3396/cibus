import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/vertical_list_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/services/login/user.dart';

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
                ],
              ),
            ),
            Divider(),
            recipes.isNotEmpty
                ? VerticalListView(
                    title: "More recipes",
                    recipes: recipes,
                  )
                : Text(kNoRecipeText), //TODO styla denna
          ],
        ),
      ),
    );
  }
}
