import 'package:flutter/material.dart';

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
enum loginType { google, facebook }

const kDefaultRecipePic = 'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/recipe_cibus_white_big.png?alt=media&token=538b32e1-69eb-4db6-a3d9-22d844592ab2';
const kDefaultProfilePic = 'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/profile_pic_coral_2.png?alt=media&token=5009199a-3810-4fb8-9ecc-b2a1359de101';

