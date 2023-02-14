import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/core/utils/states/cubit_state.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/presentation/cubits/user_cubit.dart';
import 'package:flutter_communication/feature/presentation/page/home/home_drawer.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_body.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_page.dart';
import 'package:flutter_communication/feature/presentation/page/search/search_page.dart';
import 'package:flutter_communication/other/helper/helper_function.dart';

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
  late final helper = locator<UserHelper>();
  late final user = helper.user;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocBuilder<UserCubit, CubitState<dynamic>>(
      builder: (context, state) {
        final a = state.data;
        print(a);
        return Screen(
          title: index == 0 ? AppInfo.fullName : ProfilePage.title,
          titleAllCaps: true,
          titleCenter: true,
          titleStyle: FontWeight.bold,
          background: Colors.white,
          body: index == 1 ? const ProfileBody() : const HomeBody(),
          drawer: HomeDrawer(
            currentIndex: index,
            title: user?.name ?? "Mr. Thomas",
            subtitle: user?.email,
            photo: user?.photo ??
                "https://images.unsplash.com/photo-1532318065232-2ba7c6676cd5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1223&q=80",
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
              action: () => Navigator.pushNamed(context, SearchPage.route),
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
