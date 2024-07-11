import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class userBar extends StatelessWidget{
  userBar({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  String getDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    String displayToReturn = 'N/A';

    if (user != null) {
      displayToReturn = user.email!; // <-- Their email
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
            child: Text('Logged in as: ${getDisplayName()}'),
          ),
        ],
      )
    );
  }
}