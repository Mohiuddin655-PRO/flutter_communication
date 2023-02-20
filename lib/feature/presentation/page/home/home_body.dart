import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/domain/entities/room_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat_room/live_rooms_use_case.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/chat/chat_page.dart';
import 'package:flutter_communication/feature/presentation/page/home/room_item.dart';
import 'package:flutter_communication/feature/presentation/widget/view.dart';

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
