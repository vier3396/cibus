import 'package:flutter/material.dart';
import 'package:cibus/services/models/colors.dart';

class ShowRating extends StatelessWidget {
  ShowRating({
    @required this.rating,
    @required this.imageHeight,
  });

  final double rating;
  final double imageHeight;

  double roundForStars(double x) {
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
      Icon star = Icon(Icons.star, color: kVibrantYellow, size: imageHeight,);
      listOfCibus.add(star);
    }
    if (roundedRating - roundedRating.toInt() > 0.1) {
      Icon halfStar = Icon(Icons.star_half, color: kVibrantYellow, size: imageHeight,);
      listOfCibus.add(halfStar);
    }
    return Row(children: listOfCibus);
  }
}