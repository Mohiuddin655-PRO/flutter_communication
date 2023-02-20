import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final double? width, height;
  final bool visible;
  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final TextOverflow? textOverflow;
  final double? textSize;
  final FontWeight? textStyle;
  final EdgeInsetsGeometry? margin, padding;
  final int? maxLines;
  final List<TextSpan>? spans;
  final Function()? onPressed;

  const TextView({
    Key? key,
    this.text = "",
    this.width,
    this.height,
    this.visible = true,
    this.textAlign,
    this.textColor,
    this.textOverflow,
    this.textSize,
    this.textStyle,
    this.margin,
    this.padding,
    this.maxLines,
    this.spans,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          child: Text.rich(
            TextSpan(
              text: text,
              children: spans,
            ),
            maxLines: maxLines,
            textAlign: textAlign,
            overflow: textOverflow,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: textStyle,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
