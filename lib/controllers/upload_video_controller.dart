import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  static UploadVideoController instance = Get.find();

  // Upload video
  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // Get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String url = await _uploadVideoToStorage("Video $len", videoPath);
      String thumbnail = await _uploadImageToStorage('Video $len', videoPath);

      final user = userDoc.data() as Map<String, dynamic>;

      Video video = Video(
          songName: songName,
          caption: caption,
          videoUrl: url,
          thumbnail: thumbnail,
          uid: uid,
          id: 'Video $len',
          userName: user['name'],
          profilePhoto: user['profilePhoto'],
          commentCount: 0,
          likes: [],
          shareCount: 0);

      await firestore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar('Error Uploading Video', e.toString());
    }
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("videos/$id");

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child("thumbnails/$id");
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }
}
