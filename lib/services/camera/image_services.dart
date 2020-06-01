import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageService {

  static Future<dynamic> loadImage() async{
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://independent-project-7edde.appspot.com/');
    String uRL = await _storage.ref().child('2020-04-27 15:35:07.831630.png').getDownloadURL();
    return uRL;
  }
}