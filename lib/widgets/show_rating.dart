import 'package:flutter/material.dart';

class ShowRating extends StatelessWidget {
  ShowRating({
    @required this.rating,
    @required this.imageHeight,
  });

  final double rating;
  final double imageHeight;

  double roundForStars(double x) {
    // 2.1 => 2.5; 2.5 => 2.5; 2.6 => 3.0; 3.0 => 3.0;

    int xWhole = x.toInt();
    double xDecimal = x - xWhole;
    double decimalToAdd;
    if (xDecimal < 0.1) {
      decimalToAdd = 0.0;
    } else if (xDecimal <= 0.5) {
      decimalToAdd = 0.5;
    } else {
      decimalToAdd = 1.0;
    }
    return xWhole + decimalToAdd;
  }

  @override
  Widget build(BuildContext context) {
    double roundedRating = roundForStars(rating);
    List<Widget> listOfCibus = List<Widget>();

    for (var i = 0; i < roundedRating.toInt(); i++) {
      Image star = Image(
        image: AssetImage("assets/cibus_filled.png"),
        height: imageHeight,
      );
      listOfCibus.add(star);
    }
    if (roundedRating - roundedRating.toInt() > 0.1) {
      // there should be a half cibus
      Image halfStar = Image(
        image: AssetImage("assets/cibus_filled_half.png"),
        height: imageHeight,
      );
      listOfCibus.add(halfStar);
    }
    return Row(children: listOfCibus);
  }
}