import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';

class MessageTile extends StatefulWidget {
  final MessageEntity item;

  const MessageTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
