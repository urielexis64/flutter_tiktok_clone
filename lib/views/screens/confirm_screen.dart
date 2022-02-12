import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen(
      {Key? key, required this.videoFile, required this.videoPath})
      : super(key: key);

  final File videoFile;
  final String videoPath;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController _controller;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = VideoPlayerController.file(widget.videoFile);
    });
    _controller.initialize();
    _controller.play();
    _controller.setVolume(1);
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            },
            child: SizedBox(
                height: size.height * 0.6,
                child: AspectRatio(
                  aspectRatio: 1 / 2,
                  child: VideoPlayer(_controller),
                )),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: size.width - 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextInputField(
                          controller: _songController,
                          label: 'Song Name',
                          icon: Icons.music_note)),
                  const SizedBox(height: 10),
                  Container(
                      width: size.width - 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextInputField(
                          controller: _captionController,
                          label: 'Caption',
                          icon: Icons.closed_caption)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text('Share',
                          style: TextStyle(fontSize: 20, color: Colors.white)))
                ],
              ))
        ],
      )),
    );
  }
}
