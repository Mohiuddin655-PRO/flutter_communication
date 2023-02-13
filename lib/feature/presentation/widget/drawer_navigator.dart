import 'package:flutter/material.dart';
import 'package:flutter_communication/core/utils/states/state_value.dart';

import '../../../tile_button.dart';

class DrawerNavigator extends StatelessWidget {
  final DrawerNavigatorHeader header;
  final DrawerAction action;
  final Color? background;
  final EdgeInsetsGeometry? padding, margin;
  final BorderRadius? borderRadius;
  final bool safeMode;
  final Border? border;

  const DrawerNavigator({
    Key? key,
    required this.header,
    required this.action,
    this.background,
    this.borderRadius,
    this.padding,
    this.margin,
    this.safeMode = true,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (safeMode) {
      return SafeArea(
        child: Container(
          margin: margin,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
          ),
          padding: padding,
          child: Drawer(
            backgroundColor: background,
            child: Column(
              children: [
                header,
                action,
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(width: 5, color: Colors.red)),
        padding: padding,
        child: Drawer(
          backgroundColor: background,
          child: Column(
            children: [
              header,
              action,
            ],
          ),
        ),
      );
    }
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
  final Color? background;
  final Widget? custom;

  const DrawerNavigatorHeader({
    Key? key,
    this.aspectRatio = 1 / 0.8,
    this.image,
    this.title = "Title",
    this.titleColor,
    this.titleSize = 24,
    this.titleStyle,
    this.margin = 12,
    this.background,
    this.custom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return custom ??
        AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            color: background,
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
          ),
        );
  }
}

class DrawerAction extends StatelessWidget {
  final Widget? custom;
  final bool drawerCloseable;
  final List<DrawerItem> items;

  final int selectedIndex;

  final double? height, width;
  final EdgeInsetsGeometry? margin, padding;
  final double? textSize;
  final FontWeight? textStyle;
  final double borderRadius;
  final double iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final IconAlignment iconAlignment;

  final FontWeight? Function(ButtonState state)? textStyleState;
  final List<IconData>? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final Color? Function(ButtonState state)? backgroundState;
  final Function(int index, DrawerItem item)? onPressed;

  const DrawerAction({
    super.key,
    this.height,
    this.width,
    this.drawerCloseable = true,
    this.selectedIndex = 0,
    required this.items,
    this.textSize = 16,
    this.textStyle,
    this.textStyleState,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.iconSize = 18,
    this.iconPadding,
    this.iconAlignment = IconAlignment.start,
    this.iconState,
    this.colorState,
    this.backgroundState,
    this.onPressed,
    this.custom,
  });

  @override
  Widget build(BuildContext context) {
    final length = items.length;
    final ip = iconAlignment == IconAlignment.start
        ? const EdgeInsets.only(right: 24)
        : const EdgeInsets.only(left: 24);
    final selectedItem =
        items[selectedIndex < length && selectedIndex > -1 ? selectedIndex : 0];

    return custom ??
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: length,
          itemBuilder: (c, index) {
            final item = items[index];
            final activated = selectedItem.key == item.key;
            return TileButton(
              width: width,
              height: height,
              padding: padding,
              margin: margin,
              iconPadding: iconPadding ?? ip,
              text: item.title,
              expended: iconAlignment == IconAlignment.end,
              iconAlignment: iconAlignment,
              iconState: (state) =>
                  item.icon?.detect(state == ButtonState.selected),
              borderRadius: borderRadius,
              selected: activated,
              textStyleState: textStyleState,
              colorState: colorState ??
                  (state) => state == ButtonState.selected
                      ? Colors.black
                      : Colors.grey,
              backgroundState: backgroundState ?? (state) => Colors.white,
              onClick: onPressed != null
                  ? () {
                      onPressed?.call(index, item);
                      if (drawerCloseable) Navigator.pop(context);
                    }
                  : null,
            );
          },
        );
  }
}

class DrawerItem {
  final String key;
  final String title;
  final StateValue<IconData>? icon;

  const DrawerItem({
    required this.key,
    required this.title,
    this.icon,
  });
}
