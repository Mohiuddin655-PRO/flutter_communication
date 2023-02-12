import 'package:flutter/material.dart';

import '../../../core/constants/app_info.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/themes.dart';
import '../../../core/constants/widgets.dart';

class Screen extends StatefulWidget {
  final String? title;
  final Color? background;
  final bool? lightAppbar;
  final bool hideLeadingButton;
  final bool transparentAppBar;
  final Widget body;
  final Widget leadingButton;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final bool fixedContent;
  final AppBar? appBar;

  const Screen({
    Key? key,
    required this.body,
    this.appBar,
    this.title,
    this.background,
    this.lightAppbar,
    this.hideLeadingButton = false,
    this.transparentAppBar = false,
    this.centerTitle = false,
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
    final theme = widget.lightAppbar != null
        ? widget.lightAppbar!
            ? _light
            : _dark
        : _primary;
    final mode = widget.appBar ?? (widget.title != null ? theme : _none);
    return Scaffold(
      extendBodyBehindAppBar: widget.transparentAppBar,
      appBar: widget.transparentAppBar ? _transparent : mode,
      backgroundColor: widget.background,
      body: widget.fixedContent ? SafeArea(child: widget.body) : widget.body,
    );
  }

  AppBar get _none {
    return AppBar(
      toolbarHeight: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: AppTheme.lightStatusBar,
    );
  }

  AppBar get _transparent {
    return AppBar(
      title: Text(widget.title ?? AppInfo.name),
      backgroundColor: Colors.transparent,
      iconTheme: AppTheme.iconThemeDark,
      systemOverlayStyle: AppTheme.transparentStatusBar,
      leading: widget.hideLeadingButton
          ? null
          : Widgets.iconBack(icon: widget.leadingButton, context: context),
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      actions: widget.actions,
    );
  }

  AppBar get _primary {
    return AppBar(
      title: Text(widget.title ?? AppInfo.name),
      backgroundColor: KColors.primary,
      iconTheme: AppTheme.iconThemePrimary,
      systemOverlayStyle: AppTheme.primaryStatusBar,
      leading: widget.hideLeadingButton
          ? null
          : Widgets.iconBack(icon: widget.leadingButton, context: context),
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      actions: widget.actions,
    );
  }

  AppBar get _dark {
    return AppBar(
      title: Text(widget.title ?? AppInfo.name),
      backgroundColor: KColors.primary.shade900,
      iconTheme: AppTheme.iconThemeDark,
      systemOverlayStyle: AppTheme.darkStatusBar,
      titleTextStyle: AppTheme.textThemeLight,
      leading: widget.hideLeadingButton
          ? null
          : Widgets.iconBack(icon: widget.leadingButton, context: context),
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      actions: widget.actions,
    );
  }

  AppBar get _light {
    return AppBar(
      title: Text(widget.title ?? AppInfo.name),
      backgroundColor: Colors.white,
      iconTheme: AppTheme.iconThemeLight,
      systemOverlayStyle: AppTheme.lightStatusBar,
      titleTextStyle: AppTheme.textThemeDark,
      leading: widget.hideLeadingButton
          ? null
          : Widgets.iconBack(icon: widget.leadingButton, context: context),
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      actions: widget.actions,
    );
  }
}
