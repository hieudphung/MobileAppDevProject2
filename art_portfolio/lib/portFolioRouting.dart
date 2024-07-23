import 'package:flutter/material.dart';

import 'pages/galleryPage.dart';
import 'pages/messagesPage.dart';
import 'pages/userLookupPage.dart';
import 'pages/userPage.dart';
import 'widgets/menubar.dart';

class PortfolioRouting extends StatelessWidget {
  const PortfolioRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const ToMainPage(),
        '/users': (context) => const UserLookupPage(),
        '/profile': (context) => const UserPage(userID: ''),
        '/messages': (context) => const MessagesListPage(),
      },
      initialRoute: '/',
    );
  }
}

class ToMainPage extends StatefulWidget {
  const ToMainPage({super.key});

  @override
  State<ToMainPage> createState() => _ToMainPageState();
}

class _ToMainPageState extends State<ToMainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const GalleryPage(),
    const UserLookupPage(),
    const UserPage(userID: ''),
    const MessagesListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Portfolio'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomMenuBar(
        menuItems: const ['Gallery', 'Users', 'Profile', 'Messages'],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
