import 'package:flutter/material.dart';
import 'my_text_form_field.dart';

Widget popupBodySearchIngredients() {
  return Container(
    child: ListView(
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      children: <Widget>[
        MyTextFormField(
          labelText: "Search",
        ),
      ],
    ),
  );
}