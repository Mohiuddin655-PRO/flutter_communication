import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/core/utils/states/cubit_state.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/live_messages_use_case.dart';
import 'package:flutter_communication/feature/presentation/cubits/message_cubit.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/chat/chat_item.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final cubit = context.read<MessageCubit>();
  late final liveMessage = locator<LiveMessagesUseCase>();
  late TextEditingController _controller;

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
          child: StreamBuilder(
            stream: liveMessage.call(),
            builder: (context, AsyncSnapshot snapshot) {
              print("chats : $snapshot");
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.active:
                case ConnectionState.done:
                  final response =
                      snapshot.data != null ? snapshot.data as Response : null;
                  return _Chats(
                    items: response?.result ?? [],
                  );
              }
            },
          ),
        ),
        SizedBox(
          height: 80,
          child: Row(
            children: [
              Expanded(child: _Input(controller: _controller)),
              BlocBuilder<UserCubit, CubitState>(builder: (context, state) {
                final user = state.getData<UserEntity>();
                return _SendButton(
                  onClick: () {
                    final data = MessageEntity(
                      message: _controller.text,
                      id: Entity.key,
                      time: Entity.timeMills,
                      sender: Sender(
                        id: AuthHelper.uid,
                        name: user?.name,
                        photo: user?.photo,
                      ),
                    );
                    cubit.create(entity: data);
                    _controller.text = "";
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
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
