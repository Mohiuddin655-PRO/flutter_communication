import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final Color? primary;
  final double width, height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding, margin;
  final bool loading;
  final bool loadingWithText;
  final Function()? onPressed;

  const Button({
    Key? key,
    required this.text,
    this.primary,
    this.width = double.infinity,
    this.height = 50,
    this.padding,
    this.margin,
    this.borderRadius,
    this.loading = false,
    this.loadingWithText = true,
    this.onPressed,
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final progressPadding = widget.height * 0.25;
  late final progressMargin = widget.height * 0.05;
  late final progressWidth = widget.height * 0.05;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.primary ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _textWidget,
              _spacerWidget,
              _loadingWidget,
            ]),
      ),
    );
  }

  get _textWidget => widget.loadingWithText || !widget.loading
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        )
      : Container();

  get _spacerWidget =>
      widget.loadingWithText && widget.loading ? const Spacer() : Container();

  get _loadingWidget => widget.loading
      ? Container(
          width: widget.height,
          height: widget.height,
          padding: EdgeInsets.all(progressPadding),
          margin: EdgeInsets.symmetric(horizontal: progressMargin),
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: progressWidth,
          ),
        )
      : Container();
}
