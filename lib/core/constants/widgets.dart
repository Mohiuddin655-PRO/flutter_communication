import 'package:flutter/material.dart';

class Widgets {
  static Widget iconBack({
    BuildContext? context,
    Function()? onPressed,
    Widget? icon,
  }) {
    return GestureDetector(
      onTap:
          onPressed ?? (context != null ? () => Navigator.pop(context) : null),
      child: icon ?? const Icon(Icons.arrow_back),
    );
  }
}
