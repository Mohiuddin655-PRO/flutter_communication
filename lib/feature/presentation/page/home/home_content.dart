import 'package:flutter_communication/feature/presentation/page/home/home_page.dart';
import 'package:flutter_communication/feature/presentation/page/profile/profile_page.dart';
import 'package:flutter_communication/feature/presentation/widget/drawer_navigator.dart';

class HomeContent {
  const HomeContent._();

  static const String title = HomePage.title;

  static const List<DrawerItem> drawerTitles = [
    DrawerItem(
      key: "home",
      title: title,
    ),
    DrawerItem(
      key: "profile",
      title: ProfilePage.title,
    ),
    DrawerItem(
      key: "logout",
      title: "Logout",
    )
  ];
}
