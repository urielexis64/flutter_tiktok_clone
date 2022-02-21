import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);
  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList
        .bindStream(firestore.collection('videos').snapshots().map((query) {
      List<Video> value = [];
      for (var video in query.docs) {
        value.add(Video.fromSnap(video));
      }
      return value;
    }));
  }

  likeVideo(String videoId) async {
    DocumentSnapshot doc =
        await firestore.collection('videos').doc(videoId).get();
    var uid = authController.user.uid;
    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection('videos').doc(videoId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
