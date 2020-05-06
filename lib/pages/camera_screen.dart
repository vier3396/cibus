import 'package:cibus/services/database.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:cibus/main.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/camera/uploader.dart';
import 'package:cibus/services/camera/cameraservices.dart';
import 'dart:math';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  final bool recipePhoto;
  ImageCapture({@required this.recipePhoto});
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
          // ratioX: 1.0,
          // ratioY: 1.0,
          // maxWidth: 512,
          // maxHeight: 512,
          toolbarColor: Colors.purple,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop It'),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or services.camera

  Future<void> chooseImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    var happyPhrases = [
      "Don't forget to smile!",
      "You're a great person!",
      "You're doing great!",
      "The world's a better place because of you!",
      "Keep on rocking in the free world!",
      "You're a barrel full of laughs!",
      "You're on top of the world!",
      "We're all very happy because of you!",
      "You're the best!",
      "If you were a pastry you'd be a chocolate cake full of joy!",
      "Good times never last, unless you're around",
    ];

    final _random = Random();
    String _happyQuote = happyPhrases[_random.nextInt(happyPhrases.length)];

    final user = Provider.of<User>(context);
    return Scaffold(
      // Select an image from the services.camera or gallery
      body: SafeArea(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Text(
                _happyQuote,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  iconSize: 100.0,
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.orange,
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                SizedBox(width: 100),
                IconButton(
                  iconSize: 100.0,
                  icon: Icon(
                    Icons.photo_library,
                    color: Colors.orange,
                  ),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            // Preview the image and crop it
            if (_imageFile != null) ...[
              Image.file(_imageFile),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
              Uploader(file: _imageFile)
            ]
          ],
        ),
      ),
    );
  }
}
