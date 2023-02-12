import 'package:flutter/material.dart';

import '../../../../core/constants/app_info.dart';
import '../../widget/screen.dart';
import 'search_body.dart';

class SearchPage extends StatefulWidget {
  static const String route = "search";

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: AppInfo.fullName,
      transparentAppBar: true,
      fixedContent: false,
      hideLeadingButton: true,
      background: Colors.white,
      body: SearchBody(),
    );
  }
}
