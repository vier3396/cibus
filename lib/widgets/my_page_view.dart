import 'package:cibus/widgets/to_fix_provider_in_popup_recipe.dart';
import 'package:flutter/material.dart';
import 'package:cibus/pages/userScreens/profile.dart';
import 'package:cibus/pages/userScreens/home.dart';
import 'package:cibus/pages/userScreens/favorites.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/database/database.dart';
import 'file:///C:/cibus/lib/services/models/user.dart';
import 'package:cibus/widgets/add_Recipe_Form_Add_Provider.dart';

const TextStyle bottomBarTextStyle = TextStyle(fontSize: 16.0);

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  _MyPageViewState();
  Stream userDataStream;
  bool checkIfFirst = true;

  PageController _pageController;
  int _currentPage = 0;

  Duration pageChanging = Duration(milliseconds: 300);
  Curve animationCurve = Curves.linear;

  //Called when this object is inserted into the tree (subscribe to the object). The framework will call this method exactly once for each State object it creates.
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  Stream checkIfFirstLoad(BuildContext context) {
    if (checkIfFirst) {
      final user = Provider.of<User>(context);
      userDataStream = DatabaseService(uid: user.uid).userData;
      checkIfFirst = false;
      return userDataStream;
    }
    return userDataStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          HomePage(userDataStream: checkIfFirstLoad(context)),
          WidgetToFixProvider(
            admin: false,
          ),
          Profile(userDataStream: checkIfFirstLoad(context)),
          AddRecipeFormProviderWidget(),
          FavoritesPage(userDataStream: checkIfFirstLoad(context)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: kBottomNavigationBarColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
              style: bottomBarTextStyle,
            ), // to remove title: Container(height: 0.0)
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text(
              'Search',
              style: bottomBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            title: Text(
              'Profile',
              style: bottomBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            title: Text(
              'Add',
              style: bottomBarTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text(
              'Favorites',
              style: bottomBarTextStyle,
            ),
          ),
        ],
        onTap: navigationTapped,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _currentPage,
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      duration: pageChanging,
      curve: animationCurve,
    );
  }

  //Called when this object is removed from the tree permanently. (unsubscribe from the object)
  // The framework calls this method when this State object will never build again.After the framework calls dispose, the State object is considered unmounted and the mounted property is false.
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  //Called whenever the page in the center of the viewport changes.
  void onPageChanged(int page) {
    if (this.mounted) {
      setState(() {
        this._currentPage = page;
      });
    }
  }
}
