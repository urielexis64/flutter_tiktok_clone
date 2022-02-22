import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/video_controller.dart';
import 'package:tiktok_clone/views/screens/comment_screen.dart';
import 'package:tiktok_clone/views/widgets/circle_animation.dart';
import 'package:tiktok_clone/views/widgets/video_player_item.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final VideoController videoController = Get.put(VideoController());

  final ValueNotifier<double> _opacity = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        if (_controller.isCompleted) {
          _opacity.value = 0;
          _controller.reset();
          _opacity.value = 1.0;
        }
      });
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          controller: PageController(),
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (BuildContext context, int index) {
            final video = videoController.videoList[index];
            return Stack(
              fit: StackFit.loose,
              children: [
                Positioned.fill(
                    child: GestureDetector(
                        onDoubleTap: () {
                          videoController.likeVideo(video.id);
                          _controller.forward();
                        },
                        child: VideoPlayerItem(videoUrl: video.videoUrl))),
                Positioned.fill(
                    child: Center(
                        child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: ValueListenableBuilder<double>(
                              builder: (_, value, __) {
                                return Opacity(
                                    opacity: value,
                                    child:
                                        const Icon(Icons.favorite, size: 70));
                              },
                              valueListenable: _opacity,
                            )))),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 70),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(video.userName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20)),
                                  Text(video.caption,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  Row(
                                    children: [
                                      const Icon(Icons.music_note,
                                          size: 15, color: Colors.white),
                                      Text(video.songName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  )
                                ],
                              )),
                        ),
                        Container(
                            width: 80,
                            margin: EdgeInsets.only(
                                top: size.height / 5, bottom: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildProfilePhoto(video.profilePhoto),
                                Column(children: [
                                  InkWell(
                                      onTap: () =>
                                          videoController.likeVideo(video.id),
                                      customBorder: const CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Icon(Icons.favorite,
                                            size: 40,
                                            color: video.likes.contains(
                                                    authController.user.uid)
                                                ? Colors.red
                                                : Colors.white),
                                      )),
                                  const SizedBox(height: 10),
                                  Text('${video.likes.length}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white))
                                ]),
                                Column(children: [
                                  InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  CommentScreen(id: video.id))),
                                      customBorder: const CircleBorder(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.comment,
                                            size: 30, color: Colors.white),
                                      )),
                                  const SizedBox(height: 10),
                                  Text('${video.commentCount}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white))
                                ]),
                                Column(children: [
                                  InkWell(
                                      onTap: () {},
                                      customBorder: const CircleBorder(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(Icons.reply,
                                            size: 30, color: Colors.white),
                                      )),
                                  const SizedBox(height: 10),
                                  Text('${video.shareCount}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white))
                                ]),
                                CircleAnimation(
                                    child: buildMusicAlbum(video.profilePhoto))
                              ],
                            ))
                      ],
                    ))
                  ],
                )
              ],
            );
          },
          itemCount: videoController.videoList.length,
        );
      }),
    );
  }

  buildProfilePhoto(String profilePhoto) {
    return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Positioned(
                left: 5,
                child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        profilePhoto,
                        fit: BoxFit.cover,
                      ),
                    )))
          ],
        ));
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Container(
        height: 50,
        width: 50,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.black.withOpacity(0.5),
              ]),
        ),
        child: Image.network(profilePhoto, fit: BoxFit.cover),
      ),
    );
  }
}
