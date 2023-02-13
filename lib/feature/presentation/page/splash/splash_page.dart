import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/presentation/page/auth/sign_in/auth_sign_in_page.dart';
import 'package:flutter_communication/feature/presentation/page/home/home_page.dart';
import 'package:flutter_communication/feature/presentation/page/splash/splash_view.dart';

import '../../../../dependency_injection.dart';
import '../../../../other/helper/helper_function.dart';

class SplashPage extends StatelessWidget {
  static const String title = "Splash";
  static const String route = "splash";

  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = locator<UserHelper>();
    return SplashView(
      title: "Chatty",
      subtitle: "Let's go we are chatting now",
      logo: "assets/png/logo.png",
      onRoute: (context) {
        return local.isLoggedIn
            ? Navigator.pushReplacementNamed(context, HomePage.route)
            : Navigator.pushReplacementNamed(context, AuthSignInPage.route);
      },
    );
  }
}
