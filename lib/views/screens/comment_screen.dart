import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  CommentScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  final TextEditingController _commentEditingController =
      TextEditingController();
  final CommentController _commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _commentController.updatePostId(id);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(
                    child: Obx(
                  () => ListView.builder(
                    itemCount: _commentController.comments.length,
                    itemBuilder: (context, index) {
                      final currentComment = _commentController.comments[index];
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage:
                                NetworkImage(currentComment.profilePhoto),
                          ),
                          title: Row(
                            children: [
                              Text(currentComment.username,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              Text(currentComment.comment,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                  tago.format(
                                      currentComment.datePublished.toDate()),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white)),
                              const SizedBox(width: 10),
                              Text('${currentComment.likes.length} likes',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white))
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () => _commentController.likeComment(
                                currentComment.id, authController.user.uid),
                            icon: Icon(
                              currentComment.likes
                                      .contains(authController.user.uid)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 24,
                              color: Colors.red,
                            ),
                            splashRadius: 24,
                          ));
                    },
                  ),
                )),
                const Divider(
                  color: Colors.white,
                ),
                ListTile(
                  title: TextFormField(
                    controller: _commentEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Add a comment',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  trailing: TextButton(
                      onPressed: () {
                        _commentController
                            .postComment(_commentEditingController.text);
                        _commentEditingController.clear();
                      },
                      child: const Text('Send',
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                )
              ],
            )),
      ),
    );
  }
}
