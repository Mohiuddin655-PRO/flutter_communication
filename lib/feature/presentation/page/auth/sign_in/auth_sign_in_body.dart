import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/other/helper/helper_function.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/common/responses/response.dart';
import '../../../../../core/common/widgets/toast.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/validators/validator.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../widget/button.dart';
import '../../../widget/edit_text.dart';
import '../../../widget/text_view.dart';
import '../../home/home_page.dart';
import '../sign_up/auth_sign_up_page.dart';

class AuthSignInBody extends StatefulWidget {
  const AuthSignInBody({Key? key}) : super(key: key);

  @override
  State<AuthSignInBody> createState() => _AuthSignInBodyState();
}

class _AuthSignInBodyState extends State<AuthSignInBody> {
  bool? isLoginDone;
  bool? isFacebookLoginDone;
  bool? isGoogleLoginDone;
  late String email, password;
  late bool isValidEmail, isValidPassword;
  late AuthCubit cubit = context.read<AuthCubit>();
  late UserHelper userHelper = locator<UserHelper>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: KColors.primary,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: const Icon(
                Icons.lock_open,
                color: Colors.white,
                size: 40,
              ),
            ),
            const Text(
              "Sign in",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            EditText(
              hint: 'Email',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: BorderRadius.circular(16),
              errorText: "Email isn't valid!",
              validator: (value) {
                email = value;
                isValidEmail = Validator.isValidEmail(email);
                return isValidEmail;
              },
            ),
            EditText(
              hint: 'Password',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: BorderRadius.circular(16),
              errorText: "Password isn't valid!",
              validator: (value) {
                password = value;
                isValidPassword = Validator.isValidPassword(password);
                return isValidPassword;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const TextView(
                  text: "Don't have an account? ",
                  textColor: KColors.primary,
                ),
                TextView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  text: "Sign up ",
                  textColor: KColors.primary,
                  textStyle: FontWeight.bold,
                  onPressed: () {
                    Navigator.pushNamed(context, AuthSignUpPage.route);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: (isLoginDone ?? true) ? _loginBiometric : null,
              child: AbsorbPointer(
                child: SvgPicture.asset(
                  Platform.isAndroid
                      ? 'assets/svg/finger_print.svg'
                      : 'assets/svg/face_id.svg',
                  height: 40,
                  width: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            TextView(
              margin: const EdgeInsets.only(top: 12),
              text: 'Biometric Login',
              textColor: Theme.of(context).primaryColor,
            ),
            Button(
              enabled: isLoginDone ?? true,
              text: 'Login',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: 16,
              onExecute: _loginEmail,
            ),
            Button(
              enabled: isGoogleLoginDone ?? true,
              text: 'Login with Google',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: 16,
              onExecute: _loginGoogle,
            ),
            Button(
              enabled: isFacebookLoginDone ?? true,
              text: 'Login with Facebook',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: 16,
              onExecute: _loginFacebook,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _loginEmail() async {
    if (!isValidEmail) {
      Toast.message("Please enter your email!");
    } else if (!isValidPassword) {
      Toast.message("Please enter your password!");
    } else {
      final user = UserEntity(
        email: email,
        password: password,
      );
      final response = await cubit.signInByEmail(user);
      _check(response);
    }
    return true;
  }

  Future<bool> _loginGoogle() async {
    final response = await cubit.signInByGoogle(const UserEntity());
    _check(response);
    return true;
  }

  Future<bool> _loginFacebook() async {
    final response = await cubit.signInByFacebook(const UserEntity());
    _check(response);
    return true;
  }

  Future<bool> _loginBiometric() async {
    final response = await cubit.signInByBiometric();
    _check(response);
    return true;
  }

  void _check(Response response) async {
    isLoginDone = true;
    if (response.isSuccessful || response.snapshot != null) {
      final data =
          response.getSnapshot<DataSnapshot>()?.value ?? response.result;
      final user = UserEntity.from(data);
      saveData(user);
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.route,
        (route) => false,
        arguments: user,
      );
    } else {
      Toast.message(response.message);
    }
  }

  void saveData(UserEntity entity) async => await userHelper.saveUser(entity);
}
