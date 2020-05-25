
class User {
  final String uid;
  bool isEmail;

  User({this.uid, this.isEmail});
}

class UserData {
  final String uid;
  final String name;
  final String description;
  final String username;
  final String profilePic;
  bool isEmail;
  final List<dynamic> favoriteList;
  bool loggedIn = true;

  UserData(
      {this.uid,
      this.name,
      this.description,
      this.username,
      this.profilePic,
      this.isEmail,
      this.favoriteList,
      this.loggedIn});
}

class AdminData {
  final String role;

  AdminData({this.role});
}
