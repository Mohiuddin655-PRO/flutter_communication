import '../../core/utils/helpers/auth_helper.dart';

class UserHelper {
  static bool isCurrentUid(String uid) => AuthHelper.uid == uid;
}
