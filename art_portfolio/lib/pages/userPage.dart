import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/favoriteContent.dart';
import '../widgets/friendContent.dart';
import '../widgets/uploadContent.dart';
import '../widgets/userItem.dart';
import '../widgets/userBar.dart';

class UserPageMaterial extends StatelessWidget {
  const UserPageMaterial({super.key,
  required this.userID});

  final String userID;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset : false,
            appBar: AppBar(title: const Text("User Page"),
                           backgroundColor: Colors.indigo[100]),
            body: UserPage(userID: userID)
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key,
  required this.userID});

  final String userID;
  
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    String idToUse = (userID.isEmpty) ? uid : userID;
    bool canEdit = (uid == idToUse) ? true : false;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    const Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    Expanded(
        flex: 2,
        child: 
          UserCard(userID: idToUse)
        ),
     Expanded(
        flex: 3,
        child: 
          Row(
            children: <Widget> [
              Expanded(child: UserUploads(userID: idToUse, isUser: (uid == idToUse))),
              Expanded(child: UserFavorites(userID: idToUse)),
            ]
          ),
        ),
      Expanded(
        flex: 2,
        child: 
          UserFriends(userID: idToUse)
        ),
      Expanded(
        flex: 1,
        child: Builder(
            builder: (context) {
              if (canEdit) {
                return UserEdit(userID: uid);
              } else {
                return OtherUsers(otherUserID: userID, userID: uid);
              }
            },
          ),
        )
      ],
    );
  }
}

class UserFriends extends StatelessWidget {
  const UserFriends ({super.key,
  required this.userID
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('Friends'),
          //the isUser parameter doesn't matter here
          Expanded(child: UserFriendsList(userID: userID, limitedDisplay: true, isUser: false)),
          MoreFriends(userID: userID)
        ]
      )
    );
  }
}

class UserUploads extends StatelessWidget {
  const UserUploads ({super.key,
  required this.userID,
  required this.isUser,
  });

  final String userID;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('Uploads'),
          Expanded(flex: 2, child: UserUploadsList(userID: userID, limitedDisplay: true, isUser: isUser)),
          Expanded(child: MoreUploads(userID: userID))
        ]
      )
    );
  }
}

class UserFavorites extends StatelessWidget {
  const UserFavorites ({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Text('Favorites'),
          Expanded(flex: 2, child: FavoritesList(userID: userID, limitedDisplay: true)),
          Expanded(child: MoreFavorites(userID: userID))
        ]
      )
    );
  }
}

