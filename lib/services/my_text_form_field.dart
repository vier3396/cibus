import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String labelText;
  final Function validator;
  final Function onSaved;
  final int maxLines;
  final int maxLength;
  final bool isAmount;
  final Function onTap;
  final TextEditingController controller;
  final InputDecoration decoration;
  final IconButton suffixIcon;
  final GlobalKey<FormState> formkey;

  MyTextFormField({
    this.labelText,
    this.validator,
    this.onSaved,
    this.maxLines = 1,
    this.maxLength = 30,
    this.isAmount = false,
    this.onTap,
    this.controller,
    this.decoration,
    this.suffixIcon,
    this.formkey,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      controller: controller,
      keyboardType: isAmount ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        suffixIcon: suffixIcon,
        labelText: labelText,
      ),
    );
  }
}