import 'package:flutter/material.dart';

class TileButton extends StatefulWidget {
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

  const TileButton({
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
  State<TileButton> createState() => _TileButtonState();
}

class _TileButtonState extends State<TileButton> {
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
                  TBIcon(
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
                  TBText(
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
                  TBIcon(
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

class TBText extends StatelessWidget {
  final Color? primary;
  final String? text;
  final double? textSize;
  final FontWeight? textStyle;
  final String? Function(ButtonState state)? textState;
  final Color? Function(ButtonState state)? colorState;
  final ButtonState state;

  const TBText({
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

class TBIcon extends StatelessWidget {
  final ButtonState state;
  final IconData? icon;
  final bool visible;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final IconData? Function(ButtonState state)? iconState;
  final Color? Function(ButtonState state)? colorState;

  const TBIcon({
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
