import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  final List<String> menuItems;
  final int currentIndex;
  final Function(int) onTap;

  CustomMenuBar({required this.menuItems, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(menuItems.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(Icons.home), // Replace with appropriate icons for each menu item
          label: menuItems[index],
        );
      }),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}