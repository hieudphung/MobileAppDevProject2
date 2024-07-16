import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/friendsListPage.dart';

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
                  UserName(name: streamSnapshot.data!.docs[0]['username'], avatarLink: streamSnapshot.data!.docs[0]['avatarSrc']),
                  UserAbout(description: streamSnapshot.data!.docs[0]['about']),
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

  void showUserEditDialog(BuildContext context, String description) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> updateUser(bool validate, String newDescription) async {
      if (validate) {
        await GalleryStoreService.instance.updateUserDetails(userID, newDescription);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: UserEditForm(keepingData: saveData, oldDescription: description),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                // Adding to provider
                updateUser(data['validated'], data['description']);

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
      future: GalleryStoreService.instance.getUser(userID),
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
                          onPressed: () => showUserEditDialog(context, snapshot.data!.description)
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
  required this.oldDescription});

  final Function keepingData;
  final String oldDescription;

  @override
  State<UserEditForm> createState() => _UserEditDetailFormState();
}

class _UserEditDetailFormState extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;

  String _description = '';

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

    widget.keepingData('validated', validated);
    widget.keepingData('description', _description);
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