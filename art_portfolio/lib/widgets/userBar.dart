import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/galleryStoreService.dart';

class userBar extends StatelessWidget{
  userBar({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    String displayToReturn = 'N/A';

    //Get username from database
    if (user != null) {
      displayToReturn = user.uid;
      displayToReturn = await GalleryStoreService.instance.getUsername(user.uid);
    }

    return displayToReturn;
  }
  
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: OutlinedButton(
                child: const Text('Logout'),
                onPressed: () async {
                  _logout();
                },
              )
            )
          ),
          Expanded(
            flex: 2,
            child: FutureBuilder <String> (
              future: getDisplayName(),
              builder: (BuildContext context, AsyncSnapshot<String> name) {
                if (name.hasData) {
                  return Text('Logged in as: ${name.data!}');
                }
                
                return const Text('Loading...');
              }
            )
          ),
        ],
      )
    );
  }
}