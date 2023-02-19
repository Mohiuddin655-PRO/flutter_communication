import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';

class ChatRoomHelper {
  static String roomId(String uid, List<String> rooms) {
    final contributor = "$uid-WITH-${AuthHelper.uid}";
    final admin = "${AuthHelper.uid}-WITH-$uid";
    if (rooms.contains(contributor)) {
      return contributor;
    } else {
      return admin;
    }
  }

  static String roomingUid({
    required String owner,
    required String contributor,
  }) {
    if (owner == AuthHelper.uid) {
      return contributor;
    } else {
      return owner;
    }
  }

  static bool isRoomCreated(String roomId, List<String> rooms) {
    return rooms.contains(roomId);
  }
}
