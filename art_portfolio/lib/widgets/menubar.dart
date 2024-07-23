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
          case 'Gallery':
            iconData = Icons.photo;
            break;
          case 'Users':
            iconData = Icons.people;
            break;
          case 'Profile':
            iconData = Icons.person;
            break;
          case 'Messages':
            iconData = Icons.message;
            break;
          default:
            iconData = Icons.photo;
        }

        return BottomNavigationBarItem(
          icon: Icon(iconData),
          label: menuItems[index],
          backgroundColor: const Color.fromARGB(255, 3, 89, 82),
        );
      }),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}