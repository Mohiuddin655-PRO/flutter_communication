import 'package:flutter/material.dart';

class View extends StatelessWidget {
  final BlendMode? backgroundBlendMode, foregroundBlendMode;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow, foregroundBoxShadow;
  final Widget? child;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? color, foregroundColor;
  final Gradient? gradient, foregroundGradient;
  final AlignmentGeometry? gravity;
  final DecorationImage? image, foregroundImage;
  final BoxShape shape;
  final double? width, height;
  final EdgeInsetsGeometry? margin, padding;
  final Matrix4? transform;
  final AlignmentGeometry? transformGravity;
  final bool visible;

  const View({
    Key? key,
    this.backgroundBlendMode,
    this.foregroundBlendMode,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.foregroundBoxShadow,
    this.child,
    this.clipBehavior,
    this.constraints,
    this.color,
    this.foregroundColor,
    this.gradient,
    this.foregroundGradient,
    this.gravity,
    this.image,
    this.foregroundImage,
    this.shape = BoxShape.rectangle,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.transformGravity,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        alignment: gravity,
        constraints: constraints,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        decoration: BoxDecoration(
          backgroundBlendMode: backgroundBlendMode,
          border: border,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          boxShadow: boxShadow,
          color: color,
          gradient: gradient,
          image: image,
          shape: shape,
        ),
        foregroundDecoration: BoxDecoration(
          backgroundBlendMode: foregroundBlendMode,
          border: border,
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          boxShadow: foregroundBoxShadow,
          color: foregroundColor,
          gradient: foregroundGradient,
          image: foregroundImage,
          shape: shape,
        ),
        key: key,
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        transform: transform,
        transformAlignment: transformGravity,
        child: child,
      ),
    );
  }
}
