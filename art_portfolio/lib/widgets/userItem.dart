import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <UserGalleryInfo>(
        future: GalleryStoreService.instance.getUser(userID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            
            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return Column(
                children: 
                <Widget>[
                  UserName(name: snapshot.data!.username, avatarLink: snapshot.data!.avatar),
                  UserAbout(description: snapshot.data!.description),
                ],
              );
            } else {
              return const Text("No user here!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class UserName extends StatelessWidget {
  const UserName({super.key,
  required this.name,
  required this.avatarLink
  });

  final String name;
  final String avatarLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(8.0), child: ClipRRect(
          borderRadius: BorderRadius.circular(37.5),
          child: Image.network(avatarLink, height: 75.0, width: 75.0))),
        Expanded(child: Text(name, textAlign: TextAlign.center,))
      ]
    );
  }
}

class UserAbout extends StatelessWidget {
  const UserAbout({super.key,
  required this.description
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return 
      Expanded(
      child: Card(
        child: Column(
          children: <Widget>[
            const Text('About'),
            Text(description)
          ]
        )
      )
    );
  }
}

class UserEdit extends StatelessWidget {
  const UserEdit({super.key,
  required this.userID
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {},
        )
      )
    );
  }
}

class OtherUsers extends StatelessWidget {
  const OtherUsers({super.key,
  required this.otherUserID,
  required this.userID
  });

  final String otherUserID;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        )
      )
    );
  }
}

class UserFriendsList extends StatelessWidget {
  const UserFriendsList({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GalleryStoreService.instance.getUserFriends(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
            
            if (docSize > 0) {
              
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  if (documentSnapshot['link'][0] == userID) {
                    //return Text(documentSnapshot['link'][1]);
                    return FriendRow(friendID: documentSnapshot['link'][1]);
                  } else if (documentSnapshot['link'][1] == userID){
                    return FriendRow(friendID: documentSnapshot['link'][0]);
                  }

                  return Container();
                }
              );

            } else {
              return const Text("No friends");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class FriendRow extends StatelessWidget {
  const FriendRow({super.key,
  required this.friendID});

  final String friendID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUser(friendID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(5.0), child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(snapshot.data!.avatar, height: 40.0, width: 40.0))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,)))
                ]
              );
            } else {
              return const Text("No user here!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class MoreFriends extends StatelessWidget {
  const MoreFriends({super.key,
  required this.userID
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () {},
        )
      )
    );
  }
}