import 'package:flutter/material.dart';

import '../../../../core/utils/helpers/auth_helper.dart';
import '../auth/sign_in/auth_sign_in_page.dart';
import '../home/home_page.dart';
import 'splash_view.dart';

class SplashPage extends StatelessWidget {
  static const String title = "Splash";
  static const String route = "splash";

  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashView(
      title: "Chatty",
      subtitle: "Let's go we are chatting now",
      logo: "assets/png/logo.png",
      onRoute: (context) {
        return AuthHelper.isLoggedIn
            ? Navigator.pushReplacementNamed(
                context,
                HomePage.route,
                arguments: AuthHelper.uid,
              )
            : Navigator.pushReplacementNamed(context, AuthSignInPage.route);
      },
    );
  }
}
