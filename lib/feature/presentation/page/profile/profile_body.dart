import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_content.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(ProfileContent.title),
    );
  }
}
