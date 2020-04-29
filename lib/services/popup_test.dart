import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupLayoutRecipe extends ModalRoute {
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  List<Widget> appBarActions;
  static Icon favoriteBorderIcon = Icon(Icons.favorite_border);
  static Icon favoriteFilledIcon = Icon(Icons.favorite);

  //initial favorites icon is heart icon with boarder, and isFavorite = false,
  //tooltip showing "Add to favorites"
  bool isFavorite = false;
  String favoritesToolTip = "Add to favorites";
  Icon favoritesIcon = favoriteBorderIcon;

  //Snackbar is the popup message on bottom of screen showing when added/removed from favorites
  String snackBarFavoritesText;
  SnackBar snackBarFavorites;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayoutRecipe(
      {Key key,
        this.bgColor,
        @required this.child,
        this.top = 30.0,
        this.bottom = 0.0,
        this.left = 0.0,
        this.right = 0.0,
      });

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {

    /* if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20; */

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: this.bottom,
          left: this.left,
          right: this.right,
          top: this.top),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayoutRecipe(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: PopupContent(
          content: Scaffold(
            key: GlobalKey<ScaffoldState>(),
            appBar: AppBar(
              title: Text(title),
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      print(isFavorite);
                      isFavorite =! isFavorite;
                      print(isFavorite);
                    });
                  },
                  icon: isFavorite
                      ? favoriteFilledIcon
                      : favoriteBorderIcon,
                  tooltip: isFavorite
                      ? "Added to favorites"
                      : "Removed from favorites",
                )
              ],
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }


}

class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({
    Key key,
    this.content,
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}