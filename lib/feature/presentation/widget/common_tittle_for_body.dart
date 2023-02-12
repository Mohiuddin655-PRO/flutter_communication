import 'package:flutter/material.dart';

class CommonTitleForBody extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final double? titleSize;
  final TextAlign? titleAlign;
  final EdgeInsetsGeometry? padding;

  const CommonTitleForBody({
    Key? key,
    required this.title,
    this.titleColor,
    this.titleSize,
    this.padding,
    this.titleAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        textAlign: titleAlign,
        style: TextStyle(
          color: titleColor ?? Colors.black,
          fontSize: titleSize ?? 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
