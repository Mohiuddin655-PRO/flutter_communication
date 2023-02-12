import 'package:flutter/material.dart';
import 'package:flutter_communication/core/constants/colors.dart';
import 'package:flutter_communication/feature/presentation/widget/drawer_navigator.dart';

import '../../../../tile_button.dart';

class HomeDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int index)? onStateChanged;

  const HomeDrawer({
    Key? key,
    this.currentIndex = 0,
    this.onStateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerNavigator(
      header: const DrawerNavigatorHeader(
        title: "Chatty",
      ),
      actions: [
        TileButton(
          text: "Home",
          borderRadius: 12,
          selected: currentIndex == 0,
          iconPadding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          iconState: (state) {
            if (state == ButtonState.selected) {
              return Icons.home;
            } else {
              return Icons.home_outlined;
            }
          },
          textStyleState: (state) {
            if (state == ButtonState.selected) {
              return FontWeight.bold;
            } else {
              return FontWeight.normal;
            }
          },
          colorState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary;
            } else {
              return KColors.primary.withOpacity(0.5);
            }
          },
          backgroundState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary.withOpacity(0.05);
            } else {
              return Colors.transparent;
            }
          },
          onClick: () => onStateChanged?.call(0),
        ),
        TileButton(
          text: "Profile",
          borderRadius: 12,
          selected: currentIndex == 1,
          iconPadding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          iconState: (state) {
            if (state == ButtonState.selected) {
              return Icons.person;
            } else {
              return Icons.person_outline;
            }
          },
          textStyleState: (state) {
            if (state == ButtonState.selected) {
              return FontWeight.bold;
            } else {
              return FontWeight.normal;
            }
          },
          colorState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary;
            } else {
              return KColors.primary.withOpacity(0.5);
            }
          },
          backgroundState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary.withOpacity(0.05);
            } else {
              return Colors.transparent;
            }
          },
          onClick: () => onStateChanged?.call(1),
        ),
        TileButton(
          text: "Logout",
          borderRadius: 12,
          selected: currentIndex == 2,
          iconPadding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          iconState: (state) {
            if (state == ButtonState.selected) {
              return Icons.exit_to_app;
            } else {
              return Icons.exit_to_app_outlined;
            }
          },
          textStyleState: (state) {
            if (state == ButtonState.selected) {
              return FontWeight.bold;
            } else {
              return FontWeight.normal;
            }
          },
          colorState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary;
            } else {
              return KColors.primary.withOpacity(0.5);
            }
          },
          backgroundState: (state) {
            if (state == ButtonState.selected) {
              return KColors.primary.withOpacity(0.05);
            } else {
              return Colors.transparent;
            }
          },
          onClick: () => onStateChanged?.call(2),
        ),
      ],
    );
  }
}
