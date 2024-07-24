import 'package:flutter/material.dart';

import 'common/styling.dart';
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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal, // Adjust primarySwatch to match your design
        ),
        scaffoldBackgroundColor:  const Color.fromARGB(255, 173, 238, 232), // Scaffold background color
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 69, 188, 176), // App bar background color
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 20, 20, 20),
            fontWeight: FontWeight.bold, // App bar title text weight
            fontSize: 20.0, // App bar title text size
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey[800], // Bottom navigation bar background color
          selectedItemColor: const Color.fromARGB(255, 225, 255, 72), // Selected item color
          unselectedItemColor: Colors.white, // Unselected item color
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
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
        title: const Text('Art Portfolio', style: AppTextStyles.headline1),
        backgroundColor: AppColors.appBarColor,
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
