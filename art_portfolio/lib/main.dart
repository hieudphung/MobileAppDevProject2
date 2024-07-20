import 'package:flutter/material.dart';
import 'menu_bar.dart';
import 'pages/home.dart';
import 'pages/gallery.dart';
import 'pages/profile.dart';
import 'pages/messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const MyHomePage(),
        '/gallery': (context) => const GalleryPage(),
        '/profile': (context) => const ProfilePage(),
        '/messages': (context) => const MessagesPage(),
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const GalleryPage(),
    const ProfilePage(),
    const MessagesPage(),
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
        menuItems: const ['Home', 'Gallery', 'Profile', 'Messages'],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
