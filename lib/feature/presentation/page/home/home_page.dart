import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/presentation/page/home/home_drawer.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_body.dart';
import 'package:flutter_communication/feature/presentation/page/search/search_page.dart';

import '../../../../core/constants/app_info.dart';
import '../../widget/screen.dart';
import '../auth/sign_in/auth_sign_in_page.dart';
import 'home_body.dart';

class HomePage extends StatefulWidget {
  static const String route = "home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: AppInfo.fullName,
      titleCenter: true,
      background: Colors.white,
      body: index == 1 ? const ProfileBody() : const HomeBody(),
      drawer: HomeDrawer(
        currentIndex: index,
        onStateChanged: (index) async{
          if (index == 2) {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, AuthSignInPage.route);
          } else {
            Navigator.pop(context);
            setState(() => this.index = index);
          }
        },
      ),
      actions: [
        ActionButton(
          action: () => Navigator.pushNamed(context, SearchPage.route),
          icon: Icons.search,
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ],
    );
  }
}
