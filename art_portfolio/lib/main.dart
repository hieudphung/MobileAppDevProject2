import 'package:art_portfolio/pages/userPage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'pages/portfolioLogin.dart';

import 'pages/galleryPage.dart';
import 'pages/userPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    const titleText = "Mobile App Final";
    const appBarText = "Portfolio Post";

    return MaterialApp(
      title: titleText,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 24, 132, 255),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 24, 132, 255),
                                          brightness: Brightness.light,),
        useMaterial3: true,
      ),
      home: Scaffold(
            appBar: AppBar(title: const Text(appBarText),
                           backgroundColor: Colors.indigo[100]),
            body: const TaskLoginPage()),
    );
  }
}

class TaskLoginPage extends StatelessWidget {
  const TaskLoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    //Streaming to check whether or not a user is logged in
    return  
          StreamBuilder <User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!streamSnapshot.hasData) {
            return PortfolioLogin();
          }

          //Go to landing page if logged in
          //Can replace gallery page with anything else to get to landing w/ menu bar
          return const UserPage(userID: '');
        }
    );
  }
}

