import 'package:flutter/material.dart';

class ErrorBody extends StatefulWidget {
  const ErrorBody({Key? key}) : super(key: key);

  @override
  State<ErrorBody> createState() => _ErrorBodyState();
}

class _ErrorBodyState extends State<ErrorBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error!'),
    );
  }
}
