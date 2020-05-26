import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  void openGallery(){}
  void openCamera(){}

  Future<void> showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text("Gallery"),
                onTap: () {
                  openGallery();
                },
              ),
              GestureDetector(
                child: Text("Camera"),
                onTap: () {
                  openCamera();
                },
              ),
            ],
          ),
        ),
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
