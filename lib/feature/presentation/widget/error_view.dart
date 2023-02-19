import 'package:flutter/material.dart';

import 'text_view.dart';
import 'view.dart';

class ErrorView extends StatelessWidget {
  final double? width, height;
  final String title, subtitle;
  final double textSize;
  final Color textColor;
  final IconData? icon;

  const ErrorView({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.title = "",
    this.subtitle = "No data found!",
    this.icon,
    this.textSize = 16,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return View(
      width: width,
      height: height,
      gravity: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          View(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Icon(
              size: 60,
              icon ?? Icons.insert_drive_file_outlined,
              color: textColor.withOpacity(0.5),
            ),
          ),
          TextView(
            visible: title.isNotEmpty,
            text: title,
            textStyle: FontWeight.bold,
            textSize: textSize,
            textColor: textColor,
            margin: const EdgeInsets.only(top: 8),
          ),
          TextView(
            visible: subtitle.isNotEmpty,
            text: subtitle,
            textSize: textSize * 0.75,
            textColor: textColor.withOpacity(0.5),
            margin: const EdgeInsets.only(top: 8),
          ),
        ],
      ),
    );
  }
}
