import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/utils/states/cubit_state.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/home/home_drawer.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_body.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_page.dart';
import 'package:flutter_communication/feature/presentation/page/search/search_page.dart';

import '../../../../core/constants/app_info.dart';
import '../../cubits/auth_cubit.dart';
import '../../widget/screen.dart';
import '../auth/sign_in/auth_sign_in_page.dart';
import 'home_body.dart';

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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocBuilder<UserCubit, CubitState<dynamic>>(
      builder: (context, state) {
        final user = state.data;
        return Screen(
          title: index == 0 ? AppInfo.fullName : ProfilePage.title,
          titleAllCaps: true,
          titleCenter: true,
          titleStyle: FontWeight.bold,
          //background: KColors.primary.withOpacity(0.5),
          body: index == 1 ? const ProfileBody() : const HomeBody(),
          drawer: HomeDrawer(
            currentIndex: index,
            title: user?.name,
            subtitle: user?.email,
            photo: user?.photo,
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
        context, AuthSignInPage.route, (route) => false);
  }
}
