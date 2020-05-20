import 'package:flutter/material.dart';

String inspoSubTitle = "Color eggs with food scraps";
String inspoContent =
    'Heres some quarantine crafts for you! Boil your eggs with onion skin, broccoli or beetroot blast, blueberries, spices or perhaps something else left over. A colored egg is more fun than a full trash can, right?';

String inspoTitle = "Trash bin overflow?";

String step1 =
    '1. Pour about 7 dl of water into a saucepan and bring to a boil.';
String step2 =
    '2. Choose one of the following coloring: Pink eggs - pour in 150 grams of half shredded red cabbage and 1 teaspoon vinegar. Blue eggs - Pour in 1 dl blueberries and 1 teaspoon vinegar. Yellow eggs - pour in 2 tablespoons turmeric and 1 teaspoon vinegar. Other ingredients to try out for yourself are beetroot, coffee, vegetable blast, and onion peel.';
String step3 =
    '3. Put the eggs gently and cook as usual. Let the eggs cool in the water and leave them for at least an hour in the refrigerator, preferably overnight.';
String endingDescription =
    'Depending on the length of time you leave the eggs in the water, the color may deepen and change the hue. Feel free to experiment! Since these are natural ingredients, the color can vary greatly from time to time. Just have fun with it !';

class InspoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: add content to database, but not as recipe? (use ListView builder to show content)
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'inspo_homepage',
                  child: ClipRRect(
                    child: Image(
                      image: AssetImage('assets/color_eggs.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 35.0,
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            child: Text(
              inspoTitle,
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              inspoSubTitle,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Text(
              inspoContent,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              'How to',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          //Steps
          Container(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    step1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    step2,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(step3,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(endingDescription,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width/1.2,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ClipRRect(
              child: Image(
                image: AssetImage('assets/painted_eggs_santa_maria.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
