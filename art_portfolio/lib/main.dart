import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'pages/portfolioLogin.dart';

import 'portFolioRouting.dart';

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
    return const GalleryRedirect();
  }
}

class GalleryRedirect extends StatelessWidget {
  const GalleryRedirect({super.key});

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
            return const LoginPage();
          }

          //Go to landing page if logged in
          //Can replace gallery page with anything else to get to landing w/ menu bar
          return const PortfolioRouting();
        }
    );
  }
}

