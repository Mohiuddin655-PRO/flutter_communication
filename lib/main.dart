import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/constants/app_info.dart';
import 'core/constants/themes.dart';
import 'dependency_injection.dart' as di;
import 'feature/presentation/page/auth/sign_in/auth_sign_in_page.dart';
import 'on_generate_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      title: AppInfo.name,
      initialRoute: AuthSignInPage.route,
      onGenerateRoute: OnGenerateRoute.route,
    );
  }
}
