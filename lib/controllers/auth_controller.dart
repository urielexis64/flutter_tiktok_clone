import 'dart:io';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart' as model;

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  Rx<File?> _pickedImage = Rx(null);

  File? get pickedImage => _pickedImage.value;

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return Future.error('No image selected');
    _pickedImage = Rx<File?>(File(pickedImage.path));
    Get.snackbar('Profile picture', 'Your profile picture has been updated');
  }

  // Upload to Firebase Storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics/${firebaseAuth.currentUser!.uid}');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String url = await snap.ref.getDownloadURL();
    return url;
  }

  // Register user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        // Save out user to auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
          uid: cred.user!.uid,
          name: username,
          email: email,
          profilePhoto: downloadUrl,
        );
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        Get.snackbar('Account created', 'Account created succesfully');
      } else {
        Get.snackbar(
            'Error creating an account', 'Please enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error creating an account', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        Get.snackbar('Error logging in', 'Please enter all the fields');
        return;
      }
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar('Error logging in', e.toString());
    }
  }
}
