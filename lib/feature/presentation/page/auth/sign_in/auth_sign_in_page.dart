import 'package:flutter/material.dart';

import '../../../widget/screen.dart';
import 'auth_sign_in_body.dart';

class AuthSignInPage extends StatelessWidget {
  static const String title = "Sign in";
  static const String route = "auth_sign_in";

  const AuthSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: title,
      hideToolbar: true,
      background: Colors.white,
      body: AuthSignInBody(),
    );
  }
}
