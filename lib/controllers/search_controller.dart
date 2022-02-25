import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchUsers = Rx<List<User>>([]);

  List<User> get searchUsers => _searchUsers.value;

  searchUser(String typedUser) async {
    _searchUsers.bindStream(firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((snapshot) {
      List<User> users =
          snapshot.docs.map((user) => User.fromSnapshot(user)).toList();
      return users;
    }));
  }
}
