import 'package:flutter_communication/feature/presentation/page/home/home_page.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_page.dart';
import 'package:flutter_communication/feature/presentation/widget/drawer_navigation.dart';

class HomeContent {
  const HomeContent._();

  static const String title = HomePage.title;

  static const List<DrawerNavigationItem> drawerTitles = [
    DrawerNavigationItem(
      key: "home",
      title: title,
    ),
    DrawerNavigationItem(
      key: "profile",
      title: ProfilePage.title,
    ),
    DrawerNavigationItem(
      key: "logout",
      title: "Logout",
    )
  ];
}
