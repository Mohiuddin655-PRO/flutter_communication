import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/states/cubit_state.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../widget/screen.dart';
import '../../home/home_page.dart';
import 'auth_sign_in_body.dart';

class AuthSignInPage extends StatelessWidget {
  static const String route = "auth_sign_in_page";

  const AuthSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Screen(
      background: Colors.white,
      body: BlocConsumer<AuthCubit, CubitState>(
        listener: (context, state) {
          if (state.data != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.route, (route) => false);
          }
        },
        builder: (context, state) {
          return const AuthSignInBody();
        },
      ),
    );
  }
}
