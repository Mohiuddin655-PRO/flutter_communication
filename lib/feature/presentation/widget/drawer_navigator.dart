import 'package:flutter/material.dart';

import '../../../tile_button.dart';

class DrawerNavigator extends StatelessWidget {
  final DrawerNavigatorHeader header;
  final List<TileButton> actions;

  const DrawerNavigator({
    Key? key,
    required this.header,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: <Widget>[
          header,
          ...actions,
        ],
      ),
    );
  }
}

class DrawerNavigatorHeader extends StatelessWidget {
  final double aspectRatio;
  final Widget? image;
  final String title;
  final Color? titleColor;
  final double? titleSize;
  final FontWeight? titleStyle;
  final double? margin;

  const DrawerNavigatorHeader({
    Key? key,
    this.aspectRatio = 1 / 0.8,
    this.image,
    this.title = "Title",
    this.titleColor,
    this.titleSize = 24,
    this.titleStyle,
    this.margin = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ??
              const Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey,
              ),
          SizedBox(height: margin),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: titleColor,
              fontSize: titleSize,
              fontWeight: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
