import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final double? height, width;
  final Color? color, background;
  final double? radius;
  final Function()? onPressed;

  const CommonButton({
    Key? key,
    required this.title,
    this.height,
    this.width,
    this.color,
    this.background,
    this.radius,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height ?? 35,
          width: width ?? 250,
          child: Material(
            color: background ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(radius ?? 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius ?? 20),
              onTap: onPressed,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
