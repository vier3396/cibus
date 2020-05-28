import 'package:flutter/material.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:provider/provider.dart';

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<Recipe>(context, listen: false).setListOfStepsToZero();
        Navigator.pop(context);
      },
      child: Text(
        'edit',
        style: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
