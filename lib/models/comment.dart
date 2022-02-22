import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String comment;
  final dynamic datePublished;
  final List likes;
  final String profilePhoto;
  final String uid;
  final String id;

  Comment(
      {required this.username,
      required this.comment,
      required this.datePublished,
      required this.likes,
      required this.profilePhoto,
      required this.uid,
      required this.id});

  Map<String, dynamic> toJson() => {
        'username': username,
        'comment': comment,
        'datePublished': datePublished,
        'likes': likes,
        'profilePhoto': profilePhoto,
        'uid': uid,
        'id': id,
      };

  static Comment fromSnap(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Comment(
      username: data['username'],
      comment: data['comment'],
      datePublished: data['datePublished'],
      likes: data['likes'],
      profilePhoto: data['profilePhoto'],
      uid: data['uid'],
      id: data['id'],
    );
  }
}
