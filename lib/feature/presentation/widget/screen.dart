import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen extends StatefulWidget {
  final String? title;
  final bool titleAllCaps;
  final double? titleSize;
  final Color? titleColor;
  final FontWeight? titleStyle;
  final Color? background;
  final bool? lightAppbar;
  final bool hideLeadingButton;
  final bool transparentAppBar;
  final Widget body;
  final Widget leadingButton;
  final List<ActionButton>? actions;
  final bool titleCenter;
  final double elevation;
  final bool fixedContent;
  final AppBar? appBar;
  final Widget? drawer;
  final bool hideToolbar;

  const Screen({
    Key? key,
    required this.body,
    this.appBar,
    this.drawer,
    this.hideToolbar = false,
    this.title,
    this.titleAllCaps = false,
    this.titleCenter = false,
    this.titleColor,
    this.titleSize,
    this.titleStyle,
    this.background,
    this.lightAppbar,
    this.hideLeadingButton = false,
    this.transparentAppBar = false,
    this.leadingButton = const Icon(Icons.arrow_back),
    this.elevation = 0.5,
    this.fixedContent = true,
    this.actions,
  }) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    final title =
        widget.titleAllCaps ? widget.title?.toUpperCase() : widget.title;
    return Scaffold(
      extendBodyBehindAppBar: widget.transparentAppBar,
      appBar: AppBar(
        toolbarHeight: widget.hideToolbar ? 0 : null,
        elevation: widget.elevation,
        centerTitle: widget.titleCenter,
        actions: widget.actions,
        systemOverlayStyle: widget.transparentAppBar
            ? const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
            : null,
        title: Text(
          title ?? "",
          style: TextStyle(
            color: widget.titleColor,
            fontWeight: widget.titleStyle,
            fontSize: widget.titleSize,
          ),
        ),
      ),
      backgroundColor: widget.background,
      body: widget.fixedContent ? SafeArea(child: widget.body) : widget.body,
      drawer: widget.drawer,
    );
  }
}

class ActionButton extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double padding;
  final double borderRadius;
  final Function()? action;

  final IconData? icon;
  final Color? tint;
  final double? size;
  final Widget? child;

  const ActionButton({
    Key? key,
    this.margin,
    this.padding = 8,
    this.borderRadius = 50,
    this.action,
    this.icon,
    this.tint,
    this.size = 40,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: margin,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: action,
            child: AbsorbPointer(
              child: Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(padding),
                child: child ?? Icon(icon, color: tint),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
