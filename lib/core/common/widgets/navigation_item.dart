import 'package:flutter/material.dart';

import '../../utils/states/activator_state.dart';

class NavigationItem {
  final ActivatorState<Widget> icon;
  final ActivatorState<String>? title;

  const NavigationItem({
    required this.icon,
    this.title,
  });
}
