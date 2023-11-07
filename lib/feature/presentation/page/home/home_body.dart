import 'package:flutter/material.dart' hide View;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/utils/validators/validator.dart';
import '../../../../locator.dart';
import '../../../../utils/helpers/chat_helper.dart';
import '../../../domain/entities/room_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/chat_room/live_rooms_use_case.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/error_view.dart';
import '../../widget/view.dart';
import '../chat/chat_page.dart';
import 'room_item.dart';

class HomeBody extends StatefulWidget {
  final UserEntity user;

  const HomeBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final userCubit = context.read<UserCubit>();
  late final liveRooms = locator<LiveChatsUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response>(
      stream: liveRooms.call(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const View(
              gravity: Alignment.center,
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            var response = snapshot.data?.result;
            if (response is List<RoomEntity>) {
              List<RoomEntity> list = [];
              for (var item in response) {
                if (ChatRoomHelper.isRoomingUid(item.id)) {
                  list.add(item);
                }
              }
              if (Validator.isValidList(list)) {
                return _Rooms(
                  user: widget.user,
                  userCubit: userCubit,
                  items: list,
                );
              }
            }

            return const ErrorView(
              title: "No chat found!",
              subtitle: "You didn't chat yet",
              icon: Icons.message,
            );
        }
      },
    );
  }
}

class _Rooms extends StatelessWidget {
  final UserEntity user;
  final List<RoomEntity> items;
  final UserCubit userCubit;

  const _Rooms({
    Key? key,
    required this.user,
    required this.items,
    required this.userCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return RoomItem(
          item: item,
          onClick: (item, user) {
            Navigator.pushNamed(
              context,
              ChatPage.route,
              arguments: {
                "room": item,
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
