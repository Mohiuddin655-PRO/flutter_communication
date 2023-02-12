import 'package:flutter/material.dart';

import '../../../core/common/widgets/navigation_item.dart';

class BottomNavigationBody extends StatefulWidget {
  final List<NavigationItem> items;
  final Widget Function(int index) builder;

  const BottomNavigationBody({
    Key? key,
    required this.items,
    required this.builder,
  }) : super(key: key);

  @override
  State<BottomNavigationBody> createState() => _BottomNavigationBodyState();
}

class _BottomNavigationBodyState extends State<BottomNavigationBody> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final item = widget.items[0];
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: widget.builder.call(_index),
          ),
          // BottomNavigationBar(
          //   // items: widget.items.map((item) {
          //   //   return BottomNavigationBarItem(icon: item.icon.active);
          //   // }).toList(),
          //   items: const [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: "Home",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.search),
          //       label: "Search",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       label: "Profile",
          //     ),
          //   ],
          //   currentIndex: _index,
          //   onTap: updateIndex,
          // ),
        ],
      ),
    );
  }

  void updateIndex(int index) => setState(() => _index = index);
}
