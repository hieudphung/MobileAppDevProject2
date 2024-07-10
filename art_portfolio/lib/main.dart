import 'package:flutter/material.dart';
import 'menu_bar.dart'; // Make sure the file path is correct
import 'pages/home.dart'; // Adjust paths as needed
import 'pages/gallery.dart';
import 'pages/profile.dart';
import 'pages/messages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define routes for navigation (if needed)
      routes: {
        '/': (context) => MyHomePage(),
        '/gallery': (context) => GalleryPage(),
        '/profile': (context) => ProfilePage(),
        '/messages': (context) => MessagesPage(),
      },
      initialRoute: '/', // Set the initial route to '/'
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    GalleryPage(),
    ProfilePage(),
    MessagesPage(),
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
        title: Text('Art Portfolio'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomMenuBar(
        menuItems: ['Home', 'Gallery', 'Profile', 'Messages'],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}