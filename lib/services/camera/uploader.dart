import 'package:flutter/material.dart';
import 'package:cibus/services/database.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/recipe.dart';

class Uploader extends StatefulWidget {
  final File file;
  final bool recipePhoto;

  Uploader({Key key, this.file, @required this.recipePhoto}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  String filePath;
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://independent-project-7edde.appspot.com/');

  StorageUploadTask _uploadTask;

  bool urlResult = false;

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  void getuRL(String filePath, BuildContext context) async {
    print('kompis');
    var uRL = await _storage.ref().child(filePath).getDownloadURL();
    print(uRL);
    final user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).updateUserPicture(pictureURL: uRL);
  }

  void getuRLRecipe(String filePath, BuildContext context) async {
    print('kompis recipe');
    var uRL = await _storage.ref().child(filePath).getDownloadURL();
    print(uRL);
    Provider.of<Recipe>(context).addImage(uRL);

    if (uRL != null && Provider.of<Recipe>(context).imageURL != null) {
      print('kom hit');
      urlResult = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            if (_uploadTask.isComplete && !urlResult) {
              if (widget.recipePhoto) {
                getuRLRecipe(filePath, context);
              } else if (!widget.recipePhoto) {
                getuRL(filePath, context);
              }
            }
            return Column(
              children: [
                if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
