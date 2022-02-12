import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/views/screens/confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ConfirmScreen(
                    videoFile: File(video.path),
                    videoPath: video.path,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: InkWell(
                onTap: () => _showOptionsDialog(context),
                child: Container(
                  width: 190,
                  height: 50,
                  decoration: BoxDecoration(color: buttonColor),
                  child: const Center(
                    child: Text(
                      'Add Video',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))));
  }

  _showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                    onPressed: () => pickVideo(ImageSource.gallery, context),
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Gallery',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    )),
                SimpleDialogOption(
                    onPressed: () => pickVideo(ImageSource.camera, context),
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Camera',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    )),
                SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: Row(
                      children: const [
                        Icon(Icons.cancel),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    )),
              ],
            ));
  }
}
