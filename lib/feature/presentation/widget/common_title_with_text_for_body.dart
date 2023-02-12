import 'package:flutter/material.dart';

import 'common_tittle_for_body.dart';

class CommonTitleWithTextForBody extends StatelessWidget {
  final String title, text;
  final Color? titleColor, textColor;
  final double? titleSize, textSize, textHeight;
  final TextAlign? titleAlign, textAlign;
  final EdgeInsetsGeometry? padding;
  final Color? background;

  const CommonTitleWithTextForBody({
    Key? key,
    required this.title,
    required this.text,
    this.titleColor,
    this.textColor,
    this.titleSize,
    this.textSize,
    this.textHeight,
    this.titleAlign,
    this.textAlign,
    this.padding,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background ?? Colors.white,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTitleForBody(
            title: title,
            titleColor: titleColor,
            titleSize: titleSize,
            titleAlign: titleAlign,
            padding: const EdgeInsets.only(bottom: 12),
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: textHeight,
            ),
            textAlign: textAlign,
          ),
        ],
      ),
    );
  }
}
