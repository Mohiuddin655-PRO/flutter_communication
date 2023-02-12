import 'package:flutter/material.dart';

import '../../widget/screen.dart';
import 'error_body.dart';

class ErrorPage extends StatelessWidget {
  static const String route = "error_page";

  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: "Error",
      centerTitle: true,
      body: ErrorBody(),
    );
  }
}
