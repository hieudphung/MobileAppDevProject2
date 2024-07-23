import 'package:flutter/material.dart';

import '../model/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../database/galleryStoreService.dart';

class userBar extends StatelessWidget{
  const userBar({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> getDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserGalleryInfo displayToReturn = UserGalleryInfo(id: '', avatar: '', description: '', username: 'n/a');

    //Get username from database
    if (user != null) {
      displayToReturn = await GalleryStoreService.instance.getUserByUserID(user.uid);
    }

    return displayToReturn.username;
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
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  _logout();
                },
              )
            )
          ),
          Expanded(
            flex: 3,
            child: FutureBuilder <String> (
              future: getDisplayName(),
              builder: (BuildContext context, AsyncSnapshot<String> name) {
                if (name.hasData) {
                  return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 25, 5), 
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Logged in as: ${name.data!}')
                            )
                  );
                }
                
                return const Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 25, 5), 
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Loading...')
                            )
                );
              }
            )
          ),
        ],
      )
    );
  }
}