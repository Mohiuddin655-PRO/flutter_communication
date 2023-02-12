import 'package:flutter/material.dart';

import '../../../../core/constants/app_info.dart';
import '../../widget/screen.dart';
import 'chat_body.dart';

class ChatPage extends StatefulWidget {
  static const String route = "chat";

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: AppInfo.fullName,
      transparentAppBar: true,
      fixedContent: false,
      hideLeadingButton: true,
      background: Colors.white,
      body: ChatBody(),
    );
  }
}
