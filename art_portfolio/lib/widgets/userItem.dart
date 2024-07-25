import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../common/styling.dart';
import '../pages/friendsListPage.dart';
import '../pages/messagesPage.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GalleryStoreService.instance.getUserStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;
            
            if (streamSnapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return Column(
                children: 
                <Widget>[
                  UserName(name: streamSnapshot.data!.docs[0]['username'], avatarLink: streamSnapshot.data!.docs[0]['avatarSrc'], userID: userID),
                  UserAbout(description: streamSnapshot.data!.docs[0]['about']),
                ],
              );
            } else {
              return const Text("No user here!", style: AppTextStyles.bodyText);
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
  required this.avatarLink,
  required this.userID
  });

  final String name;
  final String avatarLink;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Row(
      children: <Widget>[
        AvatarImage(avatarSrc: avatarLink, size: 50.0, padding: 8.0),
        Expanded(
          child: 
            Column(
              children: <Widget> [
                Expanded(child: Text(name, textAlign: TextAlign.center, style: AppTextStyles.bodyText)),
                Expanded(child: 
                  Row(
                    children: <Widget> [
                      const Expanded(child: Text('Uploads: ', style: AppTextStyles.bodyText)),
                      Expanded(child: 
                        StreamBuilder(
                          stream: GalleryStoreService.instance.getUserGalleryStream(userID),
                          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              int docSize = streamSnapshot.data!.size;

                              return Text('$docSize', style: AppTextStyles.bodyText);
                            }

                            return const Text('0', style: AppTextStyles.bodyText);
                          }
                      )),
                    ]
                )),
              ]
          )
        )
      ]
    ));
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
            const Text('About', style: AppTextStyles.bodyText),
            Text(description, style: AppTextStyles.bodyText)
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

  void showUserEditDialog(BuildContext context, String description, String avatarSrc) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> updateUser(bool validate, String newDescription, String newAvatarSrc) async {
      if (validate) {
        await GalleryStoreService.instance.updateUserDetails(userID, newDescription, newAvatarSrc);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile', style: AppTextStyles.bodyText),
          content: UserEditForm(keepingData: saveData, oldDescription: description, oldAvatarSrc: avatarSrc),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: AppTextStyles.bodyText),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Update', style: AppTextStyles.bodyText),
              onPressed: () async {
                // Adding to provider
                updateUser(data['validated'], data['description'], data['avatarSrc']);

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
      future: GalleryStoreService.instance.getUserByUserID(userID),
        builder: (context, AsyncSnapshot<UserGalleryInfo> snapshot) {
          if (snapshot.hasData) {
            //streamSnapshot.data!;

            if (snapshot.data != null) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
              return Padding(
                      padding: const EdgeInsets.all(8.0), 
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showUserEditDialog(context, snapshot.data!.description, snapshot.data!.avatar)
                        )
                      )
                    );
            }
          }

          return Padding(
                      padding: const EdgeInsets.all(8.0), 
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => {}
                        )
                      )
                    );
      }
    );
  }
}

class UserEditForm extends StatefulWidget {
  const UserEditForm({super.key,
  required this.keepingData,
  required this.oldDescription,
  required this.oldAvatarSrc});

  final Function keepingData;
  final String oldDescription;
  final String oldAvatarSrc;

  @override
  State<UserEditForm> createState() => _UserEditDetailFormState();
}

class _UserEditDetailFormState extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;

  String _description = '';
  String _avatarSrc = '';

  void validate() {
    if (_description.isEmpty) {
      validated = false;
    } else {
      validated = true;
    }
  }

  @override
  void initState() {
    super.initState();

    _description = widget.oldDescription;
    _avatarSrc = widget.oldAvatarSrc;

    widget.keepingData('validated', validated);
    widget.keepingData('description', _description);
    widget.keepingData('avatarSrc', _avatarSrc);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 600,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Set the Avatar Source'
              ),

              maxLines: 6,
              minLines: 1,

              initialValue: widget.oldAvatarSrc,

              onChanged: (value) {
                _avatarSrc = value;

                validate();

                setState(() {
                  widget.keepingData('validated', validated);
                  widget.keepingData('avatarSrc', _avatarSrc);
                  }
                );
              },
            ),
          ),
          SizedBox(
            width: 600,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Set the About'
              ),

              maxLines: 6,
              minLines: 1,

              initialValue: widget.oldDescription,

              onChanged: (value) {
                _description = value;

                validate();

                setState(() {
                  widget.keepingData('validated', validated);
                  widget.keepingData('description', _description);
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OtherUsers extends StatefulWidget {
  const OtherUsers({super.key,
  required this.otherUserID,
  required this.userID
  });

  final String otherUserID;
  final String userID;
  
  void _sendFriendRequestDialog(BuildContext context, bool sendDebounce) {
    if (!sendDebounce) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send this user a friend request?', style: AppTextStyles.bodyText),
          actions: <Widget>[
            TextButton(
              child: const Text('No', style: AppTextStyles.bodyText),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes', style: AppTextStyles.bodyText),
              onPressed: () async {
                // Adding to provider
                GalleryStoreService.instance.addFriendRequest(userID, otherUserID);

                // Handle adding new goal
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    }
  }

  void _goToSendMessage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComposeMessagePage(receiverID: otherUserID, title: '')));
  }

  @override
  State<OtherUsers> createState() => OtherUsersState();
}

class OtherUsersState extends State<OtherUsers> {
  bool hasSent = false;

  @override
  Widget build(BuildContext context) {
    //determine if friends
    return 
    FutureBuilder <bool>(
      future: GalleryStoreService.instance.areUsersFriends(widget.userID, widget.otherUserID),
      builder: (context, AsyncSnapshot<bool> snapshot) {
      if (snapshot.hasData) {
        if (!snapshot.data!) {
          return Padding(
          padding: const EdgeInsets.all(8.0), 
          child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            children: <Widget> [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              widget._sendFriendRequestDialog(context, hasSent);
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              widget._goToSendMessage(context);
            },
          ),
          ]
        ))); 
        }
      }

      //disabled friend request
      return Padding(
        padding: const EdgeInsets.all(8.0), 
        child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
            children: <Widget> [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              print('already friends!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              widget._goToSendMessage(context);
            },
          ),
          ]
        )));
      }
    );
  }
}

class MoreFriends extends StatelessWidget {
  const MoreFriends({super.key,
  required this.userID
  });

  final String userID;

  void _toFriendList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendsListPage(userID: userID)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () => _toFriendList(context),
        )
      )
    );
  }
}

class UserRow extends StatelessWidget {
  const UserRow({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUser(userID),
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
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left, style: AppTextStyles.bodyText))),
                ]
              ),
              onTap: () => {goToProfileTemp(context, snapshot.data!.id)}
              );
            } else {
              return const Text("No user here!", style: AppTextStyles.bodyText);
            }
          }

          return const Row(
                children: <Widget>[
                           AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                           Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Blank User', textAlign: TextAlign.left, style: AppTextStyles.bodyText))),
            ]
        );
      },
    );
  }
}