import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/responses/response.dart';
import '../../../../core/constants/app_info.dart';
import '../../../../core/utils/helpers/auth_helper.dart';
import '../../../../locator.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/user/live_user_use_case.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/user_cubit.dart';
import '../../widget/screen.dart';
import '../auth/sign_in/auth_sign_in_page.dart';
import '../profile/profile_body.dart';
import '../profile/profile_page.dart';
import '../search/search_page.dart';
import 'home_body.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  static const String title = "Home";
  static const String route = "home";

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final liveUser = locator<LiveUserUseCase>();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return StreamBuilder<Response>(
      stream: liveUser.call(uid: AuthHelper.uid),
      builder: (context, snapshot) {
        final data = snapshot.data?.result;
        final user = data is UserEntity ? data : const UserEntity();
        return Screen(
          title: index == 0 ? AppInfo.fullName : ProfilePage.title,
          titleAllCaps: true,
          titleCenter: true,
          titleStyle: FontWeight.bold,
          //background: KColors.primary.withOpacity(0.5),
          body: index == 1 ? const ProfileBody() : HomeBody(user: user),
          drawer: HomeDrawer(
            currentIndex: index,
            title: user.name,
            subtitle: user.email,
            photo: user.photo,
            onStateChanged: (index) async {
              if (index == 2) {
                await cubit.signOut();
                resignIn();
              } else {
                setState(() => this.index = index);
              }
            },
          ),
          actions: [
            ActionButton(
              action: () {
                return Navigator.pushNamed(
                  context,
                  SearchPage.route,
                  arguments: {
                    "user": user,
                    "user_cubit": context.read<UserCubit>(),
                  },
                );
              },
              icon: Icons.search,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        );
      },
    );
  }

  void resignIn() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AuthSignInPage.route,
      (route) => false,
    );
  }
}
