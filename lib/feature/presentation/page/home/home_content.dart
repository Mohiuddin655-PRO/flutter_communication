import '../../widget/drawer_navigation.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';

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
