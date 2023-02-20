import 'package:flutter/material.dart';
import 'package:flutter_communication/core/constants/colors.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/get_user_use_case.dart';

import '../../../../dependency_injection.dart';
import '../../../domain/entities/user_entity.dart';

class ChatItem extends StatefulWidget {
  final MessageEntity item;

  const ChatItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  late final size = MediaQuery.of(context).size;
  late final getUser = locator<GetUserUseCase>();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    const borderRadius = Radius.circular(20);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: FutureBuilder(
        future: getUser.call(uid: widget.item.sender),
        builder: (context, snapshot) {
          final sender = snapshot.data?.result;
          if (sender is UserEntity) {
            return Row(
              mainAxisAlignment: item.isCurrentUid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!item.isCurrentUid)
                  _UserAvatar(
                    isMe: item.isCurrentUid,
                    item: sender,
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: item.isCurrentUid
                        ? KColors.primary.shade200
                        : KColors.primary.shade50,
                    borderRadius: item.isCurrentUid
                        ? const BorderRadius.only(
                            topLeft: borderRadius,
                            topRight: borderRadius,
                            bottomLeft: borderRadius,
                          )
                        : const BorderRadius.only(
                            topLeft: borderRadius,
                            topRight: borderRadius,
                            bottomRight: borderRadius,
                          ),
                  ),
                  child: Text(
                    item.message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: item.isCurrentUid ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (item.isCurrentUid)
                  _UserAvatar(
                    isMe: item.isCurrentUid,
                    item: sender,
                  ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final bool isMe;
  final UserEntity item;

  const _UserAvatar({
    Key? key,
    required this.isMe,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(
        left: isMe ? 4 : 0,
        right: isMe ? 0 : 4,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.25),
      ),
      child: item.photo.isValid
          ? Image.network(
              item.photo,
              fit: BoxFit.cover,
            )
          : Image.asset(
              "assets/img/img_user.jpeg",
              fit: BoxFit.cover,
            ),
    );
  }
}
