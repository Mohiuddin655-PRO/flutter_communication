import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/utils/helpers/auth_helper.dart';
import '../../../../dependency_injection.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/live_users_use_case.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/error_view.dart';
import '../../widget/text_view.dart';
import '../chat/chat_page.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  late final userCubit = context.read<UserCubit>();
  late final liveUsers = locator<LiveUsersUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: liveUsers.call(),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            final response = snapshot.data;
            if (response is Response) {
              return _Users(
                userCubit: userCubit,
                items: response.result,
              );
            } else {
              return const ErrorView(
                title: "No user found!",
                subtitle: "No user available now",
              );
            }
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
          text: item.name,
        ),
        subtitle: TextView(
          text: item.email,
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
                    item.photo,
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
