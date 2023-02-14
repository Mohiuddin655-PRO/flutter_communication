import 'package:flutter/material.dart';
import 'package:flutter_communication/core/utils/states/state_value.dart';
import 'package:flutter_communication/feature/presentation/widget/drawer_navigation.dart';

import '../../../../core/constants/colors.dart';

class HomeDrawer extends StatelessWidget {
  final int currentIndex;
  final String? title, subtitle;
  final String? photo;
  final Function(int index)? onStateChanged;

  const HomeDrawer({
    Key? key,
    this.currentIndex = 0,
    this.title,
    this.subtitle,
    this.photo,
    this.onStateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerNavigation(
      header: DrawerNavigationHeader(
        title: title ?? "Chatty",
        titleColor: Colors.white,
        titleStyle: FontWeight.bold,
        image: photo != null
            ? Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  photo!,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 120,
              ),
        background: Theme.of(context).primaryColor,
      ),
      action: DrawerNavigationAction(
        selectedIndex: currentIndex,
        borderRadius: 150,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        iconPadding: const EdgeInsets.only(
          right: 16,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyleState: (state) {
          if (state == ButtonState.selected) {
            return FontWeight.bold;
          } else {
            return FontWeight.normal;
          }
        },
        colorState: (state) {
          if (state == ButtonState.selected) {
            return Colors.white;
          } else {
            return KColors.primary.withOpacity(0.5);
          }
        },
        backgroundState: (state) {
          if (state == ButtonState.selected) {
            return KColors.primary;
          } else {
            return Colors.transparent;
          }
        },
        items: const [
          DrawerNavigationItem(
            key: "home",
            title: "Home",
            icon: StateValue(
              activeValue: Icons.home,
              inactiveValue: Icons.home_outlined,
            ),
          ),
          DrawerNavigationItem(
            key: "profile",
            title: "Profile",
            icon: StateValue(
              activeValue: Icons.person,
              inactiveValue: Icons.person_outline,
            ),
          ),
          DrawerNavigationItem(
            key: "logout",
            title: "Logout",
            icon: StateValue(
              activeValue: Icons.exit_to_app,
              inactiveValue: Icons.exit_to_app_outlined,
            ),
          ),
        ],
        onPressed: (index, item) => onStateChanged?.call(index),
      ),
    );
  }
}
