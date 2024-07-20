import 'package:flutter/material.dart';

class CustomMenuBar extends StatelessWidget {
  final List<String> menuItems;
  final int currentIndex;
  final Function(int) onTap;

  const CustomMenuBar({super.key, required this.menuItems, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(menuItems.length, (index) {
        IconData iconData;
        switch (menuItems[index]) {
          case 'Home':
            iconData = Icons.home;
            break;
          case 'Gallery':
            iconData = Icons.photo;
            break;
          case 'Profile':
            iconData = Icons.person;
            break;
          case 'Messages':
            iconData = Icons.message;
            break;
          default:
            iconData = Icons.home;
        }
        return BottomNavigationBarItem(
          icon: Icon(iconData),
          label: menuItems[index],
        );
      }),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
