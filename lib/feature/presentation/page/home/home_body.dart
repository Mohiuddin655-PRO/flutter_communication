import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat_room/live_rooms_use_case.dart';
import 'package:flutter_communication/feature/domain/use_cases/user/get_user_use_case.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/chat/chat_page.dart';
import 'package:flutter_communication/feature/presentation/widget/text_view.dart';
import 'package:flutter_communication/feature/presentation/widget/view.dart';
import 'package:flutter_communication/utils/helpers/chat_helper.dart';

import '../../widget/error_view.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final userCubit = context.read<UserCubit>();
  late final liveUsers = locator<LiveChatsUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: liveUsers.call(),
      builder: (context, AsyncSnapshot snapshot) {
        print("Chat Streams : $snapshot");
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const View(
              gravity: Alignment.center,
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final response = snapshot.data;
            if (response is Response) {
              return _Rooms(
                userCubit: userCubit,
                items: response.result,
              );
            } else {
              return const ErrorView(
                title: "No chat found!",
                subtitle: "You didn't chat yet",
                icon: Icons.message,
              );
            }
        }
      },
    );
  }
}

class _Rooms extends StatelessWidget {
  final List<RoomEntity> items;
  final UserCubit userCubit;

  const _Rooms({
    Key? key,
    required this.items,
    required this.userCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _Room(
          item: item,
          //visible: item.id != AuthHelper.uid,
          onClick: (item, user) {
            Navigator.pushNamed(
              context,
              ChatPage.route,
              arguments: {
                "id": item.id,
                "user": user,
                "user_cubit": userCubit,
              },
            );
          },
        );
      },
    );
  }
}

class _Room extends StatefulWidget {
  final bool visible;
  final RoomEntity item;
  final Function(RoomEntity item, UserEntity user)? onClick;

  const _Room({
    Key? key,
    required this.item,
    this.visible = true,
    this.onClick,
  }) : super(key: key);

  @override
  State<_Room> createState() => _RoomState();
}

class _RoomState extends State<_Room> {
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
            if (user is UserEntity) {
              return ListTile(
                onTap: () => widget.onClick?.call(widget.item, user),
                title: TextView(
                  text: user.name,
                ),
                subtitle: TextView(
                  text: widget.item.recent.message,
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
          }),
    );
  }
}
