import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/utils/helpers/auth_helper.dart';
import '../../../../locator.dart';
import '../../../../utils/helpers/chat_helper.dart';
import '../../../domain/entities/room_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/chat_room/update_room_use_case.dart';
import '../../../domain/use_cases/user/live_user_use_case.dart';
import '../../cubits/user_cubit.dart';
import 'chat_body.dart';

class ChatPage extends StatefulWidget {
  static const String title = "Chat";
  static const String route = "chat";

  final RoomEntity room;
  final UserEntity user;

  const ChatPage({
    Key? key,
    required this.room,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final cubit = context.read<UserCubit>();
  late final updateRoom = locator<UpdateRoomUseCase>();
  late final liveUser = locator<LiveUserUseCase>();

  @override
  Widget build(BuildContext context) {
    updateSeen();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.user.name.isNotEmpty ? widget.user.name : ChatPage.title,
        ),
      ),
      body: widget.room.id.isNotEmpty
          ? ChatBody(
              roomId: widget.room.id,
              onCheckRoom: (roomId, data) async => true,
            )
          : StreamBuilder<Response>(
              stream: liveUser.call(uid: AuthHelper.uid),
              builder: (context, snapshot) {
                final me = snapshot.data?.result;
                if (me is UserEntity) {
                  final roomId = ChatRoomHelper.roomId(
                    widget.user.id,
                    me.chatRooms,
                  );
                  return ChatBody(
                    roomId: roomId,
                    onCheckRoom: (roomId, data) => createRoom(roomId, me),
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  Future<bool> createRoom(String roomId, UserEntity user) async {
    if (!ChatRoomHelper.isRoomCreated(roomId, user.chatRooms)) {
      return cubit.createRoom(
        roomId: roomId,
        me: user,
        friend: widget.user,
      );
    } else {
      return true;
    }
  }

  void updateSeen() {
    if (ChatRoomHelper.isSeenPermissioned(widget.room.recent.sender)) {
      updateRoom.call(id: widget.room.id, data: {
        "recent": widget.room.recent.copyWith(isSeen: true).source,
      });
    }
  }
}
