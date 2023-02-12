import 'package:flutter/material.dart';

import '../../../widget/screen.dart';
import 'auth_forget_password_body.dart';

class AuthForgetPasswordPage extends StatelessWidget {
  static const String route = "auth_forget_password_page";

  const AuthForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      background: Colors.white,
      body: AuthForgetPasswordBody(),
    );
  }
}
