import 'package:flutter/material.dart';

import '../../../core/utils/states/state_value.dart';

class DrawerNavigation extends StatelessWidget {
  final DrawerNavigationHeader header;
  final DrawerNavigationAction action;
  final Color? background;
  final EdgeInsetsGeometry? padding, margin;
  final BorderRadius? borderRadius;
  final bool safeMode;
  final Border? border;

  const DrawerNavigation({
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

class DrawerNavigationHeader extends StatelessWidget {
  final double aspectRatio;
  final Widget? image;
  final String title;
  final Color? titleColor;
  final double? titleSize;
  final FontWeight? titleStyle;
  final double? margin;
  final Color? background;
  final Widget? custom;

  const DrawerNavigationHeader({
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

class DrawerNavigationAction extends StatelessWidget {
  final Widget? custom;
  final bool drawerCloseable;
  final List<DrawerNavigationItem> items;

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
  final Function(int index, DrawerNavigationItem item)? onPressed;

  const DrawerNavigationAction({
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
            return DrawerNavigationButton(
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

class DrawerNavigationItem {
  final String key;
  final String title;
  final StateValue<IconData>? icon;

  const DrawerNavigationItem({
    required this.key,
    required this.title,
    this.icon,
  });
}

class DrawerNavigationButton extends StatefulWidget {
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final double borderRadius;
  final bool enabled;
  final bool selected;
  final Function()? onClick;
  final IconData? icon;
  final double iconSize;
  final bool expended;
  final EdgeInsetsGeometry? iconPadding;
  final IconAlignment iconAlignment;

  final String? Function(ButtonState state)? textState;
  final FontWeight? Function(ButtonState state)? textStyleState;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;
  final Color? Function(ButtonState state)? backgroundState;

  const DrawerNavigationButton({
    super.key,
    this.text,
    this.textSize = 16,
    this.textStyle,
    this.textStyleState,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = 0,
    this.enabled = true,
    this.selected = false,
    this.onClick,
    this.icon,
    this.expended = false,
    this.iconSize = 18,
    this.iconPadding,
    this.iconAlignment = IconAlignment.start,
    this.textState,
    this.iconState,
    this.colorState,
    this.backgroundState,
  });

  @override
  State<DrawerNavigationButton> createState() => _DrawerNavigationButtonState();
}

class _DrawerNavigationButtonState extends State<DrawerNavigationButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.enabled && widget.onClick != null
        ? Colors.white
        : Colors.grey.shade400;
    final background = widget.enabled && widget.onClick != null
        ? theme.primaryColor
        : Colors.grey.shade200;

    return Container(
      margin: widget.margin,
      child: Material(
        color: widget.backgroundState?.call(state) ?? background,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: InkWell(
          onTap: widget.enabled ? widget.onClick : null,
          child: AbsorbPointer(
            child: Container(
              width: widget.width,
              height: widget.padding == null ? widget.height : null,
              padding: widget.padding ??
                  EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: widget.height != null ? 0 : 12,
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == IconAlignment.start,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding: widget.iconPadding,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == IconAlignment.start &&
                      widget.expended)
                    const Spacer(),
                  _Text(
                    state: state,
                    primary: color,
                    text: widget.text,
                    textSize: widget.textSize,
                    textStyle:
                        widget.textStyleState?.call(state) ?? widget.textStyle,
                    textState: widget.textState,
                    colorState: widget.colorState,
                  ),
                  if ((widget.iconState ?? widget.icon) != null &&
                      widget.iconAlignment == IconAlignment.end &&
                      widget.expended)
                    const Spacer(),
                  _Icon(
                    visible: (widget.iconState ?? widget.icon) != null &&
                        widget.iconAlignment == IconAlignment.end,
                    state: state,
                    icon: widget.icon,
                    iconState: widget.iconState,
                    color: color,
                    colorState: widget.colorState,
                    size: widget.iconSize,
                    padding: widget.iconPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ButtonState get state {
    if (widget.enabled && widget.onClick != null) {
      if (widget.selected) {
        return ButtonState.selected;
      } else {
        return ButtonState.initial;
      }
    } else {
      return ButtonState.disabled;
    }
  }
}

class _Text extends StatelessWidget {
  final Color? primary;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final String? Function(ButtonState state)? textState;
  final Color? Function(ButtonState state)? colorState;
  final ButtonState state;

  const _Text({
    Key? key,
    required this.state,
    this.primary,
    this.text,
    this.textSize = 14,
    this.textStyle,
    this.textState,
    this.colorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textState?.call(state) ?? text ?? "",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: colorState?.call(state) ?? primary,
        fontSize: textSize,
        fontWeight: textStyle,
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final ButtonState state;
  final IconData? icon;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;

  const _Icon({
    Key? key,
    required this.state,
    this.icon,
    this.visible = true,
    this.padding,
    this.color,
    this.size,
    this.iconState,
    this.colorState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: padding,
        child: Icon(
          iconState?.call(state) ?? icon,
          color: colorState?.call(state) ?? color,
          size: size,
        ),
      ),
    );
  }
}

enum IconAlignment {
  start,
  end,
}

enum ButtonState {
  disabled,
  selected,
  initial,
}
