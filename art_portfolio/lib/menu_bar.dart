import 'package:flutter/material.dart';
import 'menu_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> menuItems = ['Home', 'Gallery', 'Profile', 'Messages'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artfolio'),
      ),
      body: Column(
        children: [
          MenuBar(
            menuItems: menuItems,
            onTap: (index) {
              // Handle menu item taps here
              print('Tapped on ${menuItems[index]}');
            },
          ),
          // Add your other content here
          Expanded(
            child: Center(
              child: Text('Your main content goes here'),
            ),
          ),
        ],
      ),
    );
  }
}
