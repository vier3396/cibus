import 'package:flutter/material.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:provider/provider.dart';

class EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        Provider.of<Recipe>(context, listen: false).setListOfStepsToZero();
        Navigator.pop(context);
      },
      elevation: 0.0,
      fillColor: Colors.grey[500].withOpacity(0.3),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text('Edit',
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            SizedBox(width: 5,),
            Icon(Icons.edit, size: 20, color: Colors.white,),
          ],
        ),
      ),
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}

/*

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

 */