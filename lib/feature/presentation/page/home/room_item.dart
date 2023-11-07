import 'package:flutter/material.dart' hide View;

import '../../../../core/common/responses/response.dart';
import '../../../../feature/index.dart';
import '../../../../locator.dart';
import '../../../../utils/helpers/chat_helper.dart';
import '../../../domain/entities/room_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../widget/text_view.dart';
import '../../widget/view.dart';

class RoomItem extends StatefulWidget {
  final bool visible;
  final RoomEntity item;
  final Function(RoomEntity item, UserEntity user)? onClick;

  const RoomItem({
    Key? key,
    required this.item,
    this.visible = true,
    this.onClick,
  }) : super(key: key);

  @override
  State<RoomItem> createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  late final getUser = locator<GetUserUseCase>();

  @override
  Widget build(BuildContext context) {
    return View(
      visible: widget.visible,
      child: FutureBuilder<Response>(
        future: getUser.call(
          uid: ChatRoomHelper.roomingUid(
            owner: widget.item.owner,
            contributor: widget.item.contributor,
          ),
        ),
        builder: (context, snapshot) {
          final user = snapshot.data?.result;
          final isSeen = ChatRoomHelper.isSeen(
            widget.item.recent.sender,
            isSeen: widget.item.recent.isSeen,
          );
          if (user is UserEntity) {
            return ListTile(
              onTap: () => widget.onClick?.call(widget.item, user),
              title: TextView(
                text: user.name,
                textStyle: isSeen ? FontWeight.normal : FontWeight.bold,
              ),
              subtitle: TextView(
                text: widget.item.recent.isCurrentUid ? "You : " : "",
                textSize: 12,
                textStyle: isSeen ? FontWeight.normal : FontWeight.w600,
                spans: [
                  TextSpan(
                    text: widget.item.recent.message,
                  ),
                  TextSpan(
                    text: " - ${widget.item.recent.time}",
                  ),
                ],
              ),
              leading: CircleAvatar(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: user.photo.isValid
                      ? Image.network(
                          user.photo,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/img/img_user.jpeg",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
