import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/responses/response.dart';
import '../../../../../core/common/widgets/toast.dart';
import '../../../../../core/utils/helpers/auth_helper.dart';
import '../../../../../core/utils/validators/validator.dart';
import '../../../../../locator.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../widget/button.dart';
import '../../../widget/edit_text.dart';
import '../../../widget/text_view.dart';
import '../../home/home_page.dart';

class AuthSignUpBody extends StatefulWidget {
  const AuthSignUpBody({Key? key}) : super(key: key);

  @override
  State<AuthSignUpBody> createState() => _AuthSignUpBodyState();
}

class _AuthSignUpBodyState extends State<AuthSignUpBody> {
  late String name, email, password;
  late bool isValidName, isValidEmail, isValidPassword;
  late AuthCubit cubit = context.read<AuthCubit>();
  late AuthHelper userHelper = locator<AuthHelper>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
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
              decoration: BoxDecoration(
                color: primaryColor,
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
              "Sign Up",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            EditText(
              hint: 'Full name',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: BorderRadius.circular(16),
              validator: (value) {
                name = value;
                isValidName = Validator.isValidString(name);
                return isValidName;
              },
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
                TextView(
                  text: "Already have an account? ",
                  textColor: primaryColor,
                ),
                TextView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  text: "Sign in ",
                  textColor: primaryColor,
                  textStyle: FontWeight.bold,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Button(
              text: 'Register',
              margin: const EdgeInsets.only(top: 24),
              borderRadius: 16,
              onExecute: _register,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _register() async {
    if (!isValidName) {
      Toast.message("Please enter your full name!");
    } else if (!isValidEmail) {
      Toast.message("Please enter your email!");
    } else if (!isValidPassword) {
      Toast.message("Please enter your password!");
    } else {
      final user = UserEntity(
        name: name,
        email: email,
        password: password,
      );
      final response = await cubit.signUpByEmail(user);
      _check(response);
    }
    return true;
  }

  void _check(Response response) async {
    if (response.isSuccessful || response.snapshot != null) {
      final data =
          response.getSnapshot<DataSnapshot>()?.value ?? response.result;
      final user = UserEntity.from(data);
      await cubit.saveData(user);
      _route(user);
    } else {
      Toast.message(response.message);
    }
  }

  void _route(UserEntity user) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomePage.route,
      (route) => false,
      arguments: user,
    );
  }
}
