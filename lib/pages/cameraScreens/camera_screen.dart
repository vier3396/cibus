import 'package:cibus/services/models/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/user.dart';
import 'package:cibus/services/camera/uploader.dart';
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
          toolbarColor: kCoral,
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

    final urecipePhotoser = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(),
      // Select an image from the services.camera or gallery
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        children: <Widget>[
          Center(
            child: Text(
              _happyQuote,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                iconSize: 100.0,
                icon: Icon(
                  Icons.photo_camera,
                  color: kDarkGrey,
                ),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                iconSize: 100.0,
                icon: Icon(
                  Icons.photo_library,
                  color: kDarkGrey,
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
          // Preview the image and crop it
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.crop,
                    size: 25.0,
                  ),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(
                    Icons.delete_outline,
                    size: 25.0,
                  ),
                  onPressed: _clear,
                ),
              ],
            ),
            Uploader(
              file: _imageFile,
              recipePhoto: widget.recipePhoto,
            )
          ]
        ],
      ),
    );
  }
}
