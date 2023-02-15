import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/feature/presentation/page/chat/chat_page.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_page.dart';
import 'package:flutter_communication/feature/presentation/page/search/search_page.dart';
import 'package:flutter_communication/feature/presentation/page/splash/splash_page.dart';

import 'dependency_injection.dart';
import 'feature/presentation/cubits/auth_cubit.dart';
import 'feature/presentation/cubits/user_cubit.dart';
import 'feature/presentation/page/auth/forget_password/auth_forget_password_page.dart';
import 'feature/presentation/page/auth/sign_in/auth_sign_in_page.dart';
import 'feature/presentation/page/auth/sign_up/auth_sign_up_page.dart';
import 'feature/presentation/page/error/error_page.dart';
import 'feature/presentation/page/home/home_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final data = settings.arguments;
    switch (settings.name) {
      //Default
      case SplashPage.route:
        return routeBuilder(widget: _splash());
      case HomePage.route:
        return routeBuilder(widget: _home(data));
      case AuthSignInPage.route:
        return routeBuilder(widget: _signIn());
      case AuthSignUpPage.route:
        return routeBuilder(widget: _signUp());
      case AuthForgetPasswordPage.route:
        return routeBuilder(widget: _forgetPassword());
      //Custom
      case ProfilePage.route:
        return routeBuilder(widget: _profile());
      case ChatPage.route:
        return routeBuilder(widget: _chat());
      case SearchPage.route:
        return routeBuilder(widget: _search());
      default:
        return routeBuilder(widget: const ErrorPage());
    }
  }
}

MaterialPageRoute routeBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}

// Default
Widget _splash() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => locator<AuthCubit>(),
      ),
      BlocProvider(
        create: (context) => locator<UserCubit>(),
      ),
    ],
    child: const SplashPage(),
  );
}

// Default
Widget _home(dynamic data) {
  final uid = data is String ? data : "";
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => locator<AuthCubit>(),
      ),
      BlocProvider(
        create: (context) => locator<UserCubit>()..get(uid: uid)..gets()..getUpdates(),
      ),
    ],
    child: const HomePage(),
  );
}

Widget _signIn() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const AuthSignInPage(),
  );
}

Widget _signUp() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const AuthSignUpPage(),
  );
}

Widget _forgetPassword() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const AuthForgetPasswordPage(),
  );
}

// Custom

Widget _profile() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const ProfilePage(),
  );
}

Widget _chat() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const ChatPage(),
  );
}

Widget _search() {
  return BlocProvider(
    create: (context) => locator<AuthCubit>()..isLoggedIn,
    child: const SearchPage(),
  );
}
