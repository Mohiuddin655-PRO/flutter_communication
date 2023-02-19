import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';

import 'chat_body.dart';

class ChatPage extends StatefulWidget {
  static const String title = "Chat";
  static const String route = "chat";

  final UserEntity user;

  const ChatPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.user.name.isNotEmpty ? widget.user.name : ChatPage.title,
        ),
      ),
      body: ChatBody(
        friend: widget.user,
      ),
    );
  }
}
