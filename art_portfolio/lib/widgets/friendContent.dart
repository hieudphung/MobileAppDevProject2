import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../database/galleryStoreService.dart';
import '../model/user.dart';

class UserFriendsList extends StatelessWidget {
  const UserFriendsList({super.key,
  required this.userID,
  required this.limitedDisplay,
  required this.isUser,
  });

  final String userID;
  final bool limitedDisplay;
  final bool isUser;

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
                itemCount: (limitedDisplay && docSize > 3) ? 3 : docSize,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  if (documentSnapshot['link'][0] == userID) {
                    //return Text(documentSnapshot['link'][1]);
                    return (limitedDisplay) ? ShortenedFriendRow(friendID: documentSnapshot['link'][1]) : FriendRow(friendLinkID: documentSnapshot.id, friendID: documentSnapshot['link'][1], isUser: isUser);
                  } else if (documentSnapshot['link'][1] == userID){
                    return (limitedDisplay) ? ShortenedFriendRow(friendID: documentSnapshot['link'][0]) : FriendRow(friendLinkID: documentSnapshot.id, friendID: documentSnapshot['link'][0], isUser: isUser);
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

class ShortenedFriendRow extends StatelessWidget {
  const ShortenedFriendRow({super.key,
  required this.friendID});

  final String friendID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUserByUserID(friendID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return 
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    AvatarImage(avatarSrc: snapshot.data!.avatar, size: 30.0, padding: 5.0),
                    Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,)))
                  ]
                ),
                onTap: () => {goToProfile(context, friendID)}
              );
            } else {
              return const Text("No user here!");
            }
          }

          return const Row(
                  children: <Widget>[
                    AvatarImage(avatarSrc: '', size: 30.0, padding: 5.0),
                    Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Blank User', textAlign: TextAlign.left,)))
            ]
          );
        },
    );
  }
}

class FriendRow extends StatelessWidget {
  const FriendRow({super.key,
  required this.friendLinkID,
  required this.friendID,
  required this.isUser});

  final String friendLinkID;
  final String friendID;
  final bool isUser;

  void showUnfriendDialog(BuildContext context) {

    Future<void> unfriend() async {
      await GalleryStoreService.instance.removeFriendLink(friendLinkID);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to unfriend?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Adding to provider
                unfriend();

                // Handle adding new goal
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUserByUserID(friendID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return 
              GestureDetector(
              child: Row(
                  children: <Widget>[
                    AvatarImage(avatarSrc: snapshot.data!.avatar, size: 46.0, padding: 14.0),
                    Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,))),
                    Builder(
                      builder: (context) {
                      if (isUser) return Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.cancel), onPressed: () {showUnfriendDialog(context);})));
                      return Container();
                    })
                  ]
                ),
              onTap: () => {goToProfile(context, friendID)}
              );
            } else {
              return const Text("No user here!");
            }
          }

          return Row(
                children: <Widget>[
                  const AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                  const Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Loading...', textAlign: TextAlign.left,))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.cancel), onPressed: () {})))
            ]
          );
        },
    );
  }
}

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key,
  required this.userID
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GalleryStoreService.instance.getFriendRequests(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length; 
             
            if (docSize > 0) {
              return ListView.builder(
                itemCount: docSize,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  if (documentSnapshot['recipient'] == userID) {
                    //return an incoming friend request
                    return RequestRow(senderID: documentSnapshot['requestee']);
                  } else if (documentSnapshot['requestee'] == userID) {
                    return SendRow(recipientID: documentSnapshot['recipient']);
                  }

                  return Container();
                }
              );

            } else {
              return const Text("No friend requests");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class RequestRow extends StatelessWidget {
  const RequestRow({super.key,
  required this.senderID});

  final String senderID;

  void showRequestForm(BuildContext context) {
    print('accept friend request?');
  }

  void showDeclineForm(BuildContext context) {
    print('decline friend request?');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUserByUserID(senderID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return 
              GestureDetector(
              child: Row(
                children: <Widget>[
                  AvatarImage(avatarSrc: snapshot.data!.avatar, size: 46.0, padding: 14.0),
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,))),
                  const Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Incoming', textAlign: TextAlign.right,))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.check), onPressed: () {showRequestForm(context);}))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.cancel), onPressed: () {showDeclineForm(context);})))
                ]
              ),
              onTap: () => {goToProfileTemp(context, senderID)}
              );
            } else {
              return const Text("No user here!");
            }
          }

          return Row(
                children: <Widget>[
                            const AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                            const Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Blank User', textAlign: TextAlign.left,))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.check), onPressed: () {}))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.cancel), onPressed: () {})))
            ]
          );
        },
    );
  }
}

class SendRow extends StatelessWidget {
  const SendRow({super.key,
  required this.recipientID});

  final String recipientID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUserByUserID(recipientID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return 
              GestureDetector(
              child: Row(
                children: <Widget>[
                            AvatarImage(avatarSrc: snapshot.data!.avatar, size: 46.0, padding: 14.0),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,))),
                            const Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Pending...')))
                ]
              ),
              onTap: () => {goToProfile(context, recipientID)}
              );
            } else {
              return const Text("No user here!");
            }
          }
 
          return const Row(
                children: <Widget>[
                            AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                            Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Blank User', textAlign: TextAlign.left,))),
                            Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Pending...')))
                ]
              );
        },
    );
  }
}
