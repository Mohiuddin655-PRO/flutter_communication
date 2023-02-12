import 'package:fluttertoast/fluttertoast.dart' as t;

class Toast {
  static message(String message) {
    t.Fluttertoast.showToast(
      msg: message,
      toastLength: t.Toast.LENGTH_SHORT,
      gravity: t.ToastGravity.BOTTOM,
    );
  }
}
