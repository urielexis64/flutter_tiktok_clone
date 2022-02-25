import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    _profileController.updateUID(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black12,
                leading: const Icon(Icons.person_add_alt_outlined),
                actions: const [Icon(Icons.more_horiz_outlined)],
                centerTitle: true,
                title: Text(controller.user['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: controller.user['profilePhoto'],
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                      placeholder: (_, __) => const CircularProgressIndicator(),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(controller.user['following'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          const Text('Following',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(controller.user['followers'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          const Text('Followers',
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(controller.user['likes'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          const Text('Likes', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        if (widget.uid == authController.user.uid) {
                          authController.signOut();
                        } else {
                          controller.followUser();
                        }
                      },
                      child: Text(widget.uid == authController.user.uid
                          ? 'Sign out'
                          : controller.user['isFollowing']
                              ? 'Unfollow'
                              : 'Follow')),
                  // Video list
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: controller.user['thumbnails'].length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              crossAxisSpacing: 5),
                      itemBuilder: (_, index) {
                        final thumbnail = controller.user['thumbnails'][index];
                        return CachedNetworkImage(
                          imageUrl: thumbnail,
                          fit: BoxFit.cover,
                        );
                      })
                ],
              ),
            ),
          );
        });
  }
}
