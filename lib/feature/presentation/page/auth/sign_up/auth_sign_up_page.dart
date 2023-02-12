import 'package:flutter/material.dart';

import '../../../widget/screen.dart';
import 'auth_sign_up_body.dart';

class AuthSignUpPage extends StatelessWidget {
  static const String route = "auth_sign_up";

  const AuthSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      hideToolbar: true,
      background: Colors.white,
      body: AuthSignUpBody(),
    );
  }
}
