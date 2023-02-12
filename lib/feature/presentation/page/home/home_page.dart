import 'package:flutter/material.dart';

import '../../../../core/constants/app_info.dart';
import '../../widget/screen.dart';
import 'home_body.dart';

class HomePage extends StatefulWidget {
  static const String route = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: AppInfo.fullName,
      transparentAppBar: true,
      fixedContent: false,
      hideLeadingButton: true,
      background: Colors.white,
      body: HomeBody(),
    );
  }
}
