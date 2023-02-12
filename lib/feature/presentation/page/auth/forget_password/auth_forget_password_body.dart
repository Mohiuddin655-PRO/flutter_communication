import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/responses/response.dart';
import '../../../../../core/common/widgets/toast.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/validators/validator.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../cubits/auth_cubit.dart';
import '../../../widget/button.dart';
import '../../../widget/edit_text.dart';
import '../../home/home_page.dart';

class AuthForgetPasswordBody extends StatefulWidget {
  const AuthForgetPasswordBody({Key? key}) : super(key: key);

  @override
  State<AuthForgetPasswordBody> createState() => _AuthForgetPasswordBodyState();
}

class _AuthForgetPasswordBodyState extends State<AuthForgetPasswordBody> {
  late String name, email, password;
  late bool isValidName, isValidEmail, isValidPassword;
  late AuthCubit cubit = context.read();

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
              "Forget password",
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
              validator: (value) {
                name = value;
                isValidName = Validator.isValidString(name);
                return isValidName;
              },
            ),
            Button(
              text: 'Search by email',
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

  void _check(Response response) {
    if (response.isSuccessful || response.snapshot != null) {
      final data =
          response.getSnapshot<DataSnapshot>()?.value ?? response.result;
      final user = UserEntity.from(data);
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
}
