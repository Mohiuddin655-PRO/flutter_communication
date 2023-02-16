import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/core/utils/helpers/auth_helper.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/chat/chat_page.dart';
import 'package:flutter_communication/feature/presentation/widget/text_view.dart';

import '../../../domain/use_cases/user/live_user_use_case.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final userCubit = context.read<UserCubit>();
  late final liveUsers = locator<LiveUsersUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: liveUsers.call(),
      builder: (context, AsyncSnapshot snapshot) {
        print("User Streams : $snapshot");
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            final response = snapshot.data as Response;
            return _Users(
              userCubit: userCubit,
              items: response.result,
            );
        }
      },
    );
  }
}

class _Users extends StatelessWidget {
  final List<UserEntity> items;
  final UserCubit userCubit;

  const _Users({
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
        return _User(
          item: item,
          visible: item.id != AuthHelper.uid,
          onClick: (item) {
            Navigator.pushNamed(
              context,
              ChatPage.route,
              arguments: {
                "user": item,
                "user_cubit": userCubit,
              },
            );
          },
        );
      },
    );
  }
}

class _User extends StatelessWidget {
  final bool visible;
  final UserEntity item;
  final Function(UserEntity item)? onClick;

  const _User({
    Key? key,
    required this.item,
    this.visible = true,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ListTile(
        onTap: () => onClick?.call(item),
        title: TextView(
          text: item.name ?? "",
        ),
        subtitle: TextView(
          text: item.email ?? "",
        ),
        leading: CircleAvatar(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: item.photo.isValid
                ? Image.network(
                    item.photo ?? "",
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/img/img_user.jpeg",
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
