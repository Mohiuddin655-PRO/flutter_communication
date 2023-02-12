import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final double size;
  final double? borderRadius;
  final IconData icon;
  final Function()? onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    this.borderRadius,
    this.size = 40,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 50),
            ),
            child: Icon(icon),
          ),
        ),
      ],
    );
  }
}
