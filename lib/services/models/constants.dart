import 'package:flutter/material.dart';

//Text
const kCibusLogoText = Text(
  'CIBUS',
  style: kCibusLogoTextStyle,
);
const TextStyle kTextStyleErrorMessage =
    TextStyle(color: Colors.red, fontSize: 14.0);

const TextStyle kTextStyleRegisterButton =
    TextStyle(color: Colors.white, fontSize: 20.0);

const kMinButtonWidth = 120.0;
const EdgeInsets kFormPadding =
EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0);

const TextStyle kCibusLogoTextStyle = TextStyle(
  fontSize: 50.0,
  letterSpacing: 3.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

//Text decoration
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0)),
);

//Pictures
const kDefaultRecipePic =
    'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/recipe_cibus_white_big.png?alt=media&token=538b32e1-69eb-4db6-a3d9-22d844592ab2';
const kDefaultProfilePic =
    'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/profile_pic_coral_2.png?alt=media&token=5009199a-3810-4fb8-9ecc-b2a1359de101';

//
var kAgeList = Iterable<int>.generate(90).toList();
enum WhatToShow { none, foundIngredient, notYetSea }
enum loginType { google, facebook }
