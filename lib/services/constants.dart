import 'package:flutter/material.dart';

enum loginType { google, facebook }

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

var kageList = Iterable<int>.generate(90).toList();

enum WhatToShow { none, foundIngredient, notYetSea }
