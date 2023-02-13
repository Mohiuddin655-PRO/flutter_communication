import 'package:flutter/material.dart';

import '../../widget/screen.dart';
import 'profile_body.dart';

class ProfilePage extends StatefulWidget {
  static const String title = "Profile";
  static const String route = "profile";

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: ProfilePage.title,
      transparentAppBar: true,
      fixedContent: false,
      hideLeadingButton: true,
      background: Colors.white,
      body: ProfileBody(),
    );
  }
}
