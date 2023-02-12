import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primarySwatch: KColors.primary,
    scaffoldBackgroundColor: KColors.primaryBackground,
    appBarTheme: primaryAppBarTheme,
  );

  static AppBarTheme primaryAppBarTheme = AppBarTheme(
    systemOverlayStyle: primaryStatusBar,
    titleTextStyle: textThemeLight,
  );

  static AppBarTheme lightAppbarTheme = AppBarTheme(
    systemOverlayStyle: lightStatusBar,
    titleTextStyle: textThemeDark,
  );

  static AppBarTheme darkAppbarTheme = AppBarTheme(
    systemOverlayStyle: darkStatusBar,
    titleTextStyle: textThemeLight,
  );

  static AppBarTheme noAppbarTheme = AppBarTheme(
    systemOverlayStyle: transparentStatusBar,
    toolbarHeight: 0,
    elevation: 0,
  );

  static SystemUiOverlayStyle transparentStatusBar = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle primaryStatusBar = const SystemUiOverlayStyle(
    statusBarColor: KColors.primary,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle lightStatusBar = const SystemUiOverlayStyle(
    statusBarColor: KColors.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle darkStatusBar = SystemUiOverlayStyle(
    statusBarColor: KColors.primary.shade900,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );

  static TextStyle textThemeLight = const TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static TextStyle textThemeDark = const TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  static IconThemeData iconThemePrimary = const IconThemeData(
    color: Colors.white,
  );

  static IconThemeData iconThemeLight = const IconThemeData(
    color: Colors.black,
  );

  static IconThemeData iconThemeDark = const IconThemeData(
    color: Colors.white,
  );
}
