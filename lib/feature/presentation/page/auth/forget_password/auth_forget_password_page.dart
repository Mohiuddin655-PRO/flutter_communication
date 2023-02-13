import 'package:flutter/material.dart';

import '../../../widget/screen.dart';
import 'auth_forget_password_body.dart';

class AuthForgetPasswordPage extends StatelessWidget {
  static const String title = "Forget Password";
  static const String route = "auth_forget_password";

  const AuthForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: title,
      hideToolbar: true,
      background: Colors.white,
      body: AuthForgetPasswordBody(),
    );
  }
}
