import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.uid,
  });

  String name;
  String email;
  String profilePhoto;
  String uid;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'profilePhoto': profilePhoto,
        'uid': uid,
      };

  static User fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      name: data['name'],
      email: data['email'],
      profilePhoto: data['profilePhoto'],
      uid: data['uid'],
    );
  }
}
