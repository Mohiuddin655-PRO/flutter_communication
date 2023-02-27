import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/utils/helpers/auth_helper.dart';
import '../../../../locator.dart';
import '../../../domain/entities/base_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/entities/room_entity.dart';
import '../../../domain/use_cases/chat/add_message_use_case.dart';
import '../../../domain/use_cases/chat/live_messages_use_case.dart';
import '../../../domain/use_cases/chat_room/create_room_use_case.dart';
import '../../../domain/use_cases/chat_room/update_room_use_case.dart';
import '../../../domain/use_cases/user/get_user_use_case.dart';
import '../../../domain/use_cases/user/user_update_use_case.dart';
import '../../widget/error_view.dart';
import 'chat_item.dart';

class ChatBody extends StatefulWidget {
  final String roomId;
  final Future<bool> Function(String roomId, MessageEntity data) onCheckRoom;

  const ChatBody({
    Key? key,
    required this.roomId,
    required this.onCheckRoom,
  }) : super(key: key);

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final createRoom = locator<CreateRoomUseCase>();
  late final updateRoom = locator<UpdateRoomUseCase>();
  late final getUser = locator<GetUserUseCase>();
  late final updateUser = locator<UpdateUserUseCase>();
  late final addMessage = locator<AddMessageUseCase>();
  late final liveMessage = locator<LiveMessagesUseCase>();
  late TextEditingController _controller;
  late List<MessageEntity> items = [];

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<Response<dynamic>>(
            stream: liveMessage.call(roomId: widget.roomId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.result;
                  if (data is List<MessageEntity>) {
                    return _Chats(items: data);
                  } else {
                    return const ErrorView(
                      icon: Icons.message,
                      subtitle: "No message found!",
                    );
                  }
              }
            },
          ),
        ),
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(child: _Input(controller: _controller)),
              FutureBuilder(builder: (context, snapshot) {
                return _SendButton(
                  onClick: () {
                    final data = MessageEntity(
                      message: _controller.text,
                      id: Entity.key,
                      timeMS: Entity.timeMills,
                      sender: AuthHelper.uid,
                    );
                    sendMessage(widget.roomId, data);
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  void sendMessage(String roomId, MessageEntity data) async {
    if (data.message.isNotEmpty) {
      _controller.text = "";
      final created = await widget.onCheckRoom.call(widget.roomId, data);
      if (created) {
        await addMessage.call(roomId: roomId, entity: data);
        await updateRoom.call(id: roomId, data: {
          RoomKeys.recent: data.source,
        });
      }
    }
  }
}

class _Chats extends StatefulWidget {
  final List<MessageEntity> items;

  const _Chats({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<_Chats> createState() => _ChatsState();
}

class _ChatsState extends State<_Chats> {
  final _controller = ScrollController();
  late final keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> _keyboardSubscription;
  var _disposeIsCalled = false;

  Future<void> _scrollDown({bool isFromKeyboardListen = false}) async {
    if (isFromKeyboardListen) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposeIsCalled) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      _scrollDown(isFromKeyboardListen: true);
    });
    _scrollDown();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _Chats oldWidget) {
    _scrollDown();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _disposeIsCalled = true;
    _keyboardSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      controller: _controller,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return ChatItem(
          item: item,
        );
      },
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;

  const _Input({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            hintText: "Type something...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  final Function()? onClick;

  const _SendButton({
    Key? key,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: onClick,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
