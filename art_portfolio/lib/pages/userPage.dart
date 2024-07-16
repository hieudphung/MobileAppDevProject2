import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/userItem.dart';
import '../widgets/userBar.dart';

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
    Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    Expanded(
        flex: 1,
        child: 
          UserCard(userID: idToUse)
        ),
     Expanded(
        flex: 1,
        child: 
          UserFriends(userID: idToUse)
        ),
     Expanded(
        flex: 1,
        child: 
          UserUploads(userID: idToUse)
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
          Expanded(child: UserFriendsList(userID: userID)),
          MoreFriends(userID: userID)
        ]
      )
    );
  }
}

class UserUploads extends StatelessWidget {
  const UserUploads ({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
  /*
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GalleryStoreService.instance.getUserGalleryStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
            if (docSize > 0) {
              final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[i];

              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return GalleryItem(index: index, galleryImage: galleryImages[index]);
                }
              );
            } else {
              return const Text("No images uploaded!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
  */
}