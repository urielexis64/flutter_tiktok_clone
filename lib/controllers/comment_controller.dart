import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/comment.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = '';
  updatePostId(String id) {
    _postId = id;
    getComment();
  }

  getComment() async {
    _comments.bindStream(firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .snapshots()
        .map((comment) {
      List<Comment> retValue = [];
      for (var element in comment.docs) {
        retValue.add(Comment.fromSnap(element));
      }
      return retValue;
    }));
  }

  likeComment(String commentId, String uid) async {
    DocumentSnapshot snap = await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(commentId)
        .get();

    bool isAlreadyLiked = (snap.data() as dynamic)['likes'].contains(uid);

    await firestore
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'likes': isAlreadyLiked
          ? FieldValue.arrayRemove([uid])
          : FieldValue.arrayUnion([uid])
    });
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(authController.user.uid)
            .get();
        final userData = userDoc.data()! as dynamic;
        final allDocs = await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;

        Comment comment = Comment(
          username: userData['name'],
          comment: commentText.trim(),
          profilePhoto: userData['profilePhoto'],
          uid: userData['uid'],
          datePublished: DateTime.now(),
          likes: [],
          id: 'Comment $len',
        );

        await firestore
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());

        DocumentSnapshot snap =
            await firestore.collection('videos').doc(_postId).get();
        await firestore.collection('videos').doc(_postId).update(
            {'commentCount': (snap.data() as dynamic)['commentCount'] + 1});
      }
    } catch (e) {
      Get.snackbar('Error While Commenting', e.toString());
    }
  }
}
