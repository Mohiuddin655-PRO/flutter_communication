import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/live_user_use_case.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';

import '../../../../dependency_injection.dart';
import '../../../../utils/helpers/chat_helper.dart';
import 'chat_body.dart';

class ChatPage extends StatefulWidget {
  static const String title = "Chat";
  static const String route = "chat";

  final String roomId;
  final UserEntity user;

  const ChatPage({
    Key? key,
    required this.roomId,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final cubit = context.read<UserCubit>();
  late final liveUser = locator<LiveUserUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.user.name.isNotEmpty ? widget.user.name : ChatPage.title,
        ),
      ),
      body: widget.roomId.isNotEmpty
          ? ChatBody(
              roomId: widget.roomId,
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
      print("ROOM_INITIAL : $roomId");
      return cubit.createRoom(
        roomId: roomId,
        me: user,
        friend: widget.user,
      );
    } else {
      print("ROOM_CREATED : $roomId");
      return true;
    }
  }
}
