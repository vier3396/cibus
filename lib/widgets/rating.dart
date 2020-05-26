import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/recipe.dart';

class RatingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Text(
        Provider.of<Recipe>(context).rating ?? 'Not yet rated',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}