import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    switch (settings.name) {
      case HomePage.route:
        return routeBuilder(widget: _home());
      case AuthSignInPage.route:
        return routeBuilder(widget: _signIn());
      case AuthSignUpPage.route:
        return routeBuilder(widget: _signUp());
      case AuthForgetPasswordPage.route:
        return routeBuilder(widget: _forgetPassword());
      default:
        return routeBuilder(widget: const ErrorPage());
    }
  }
}

MaterialPageRoute routeBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}

Widget _home() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => locator<UserCubit>(),
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
