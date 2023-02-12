import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class CommonDivider extends StatelessWidget {
  final double? height, width, space;
  final Color? color;

  const CommonDivider({
    Key? key,
    this.space,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: space ?? 0),
          width: width ?? double.infinity,
          child: Divider(
            color: color ?? KColors.primary.withOpacity(0.4),
            height: 5,
            thickness: height ?? 2,
          ),
        ),
      ],
    );
  }
}
