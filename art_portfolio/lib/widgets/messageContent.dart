import 'package:art_portfolio/common/common.dart';
import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/messagesPage.dart';

class MessagesList extends StatelessWidget {
  const MessagesList ({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GalleryStoreService.instance.getUserMessagesStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            int docSize = streamSnapshot.data!.docs.length;
            
            //check if need to search
            if (docSize > 0) {
                return ListView.builder(
                itemCount: docSize,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  if (documentSnapshot['receiverID'] == userID) {
                    //return an incoming friend request
                    return MessageRecieveRow(senderID: documentSnapshot['senderID'], title: documentSnapshot['title'], message: documentSnapshot['message'], messageID: documentSnapshot.id);
                  } else if (documentSnapshot['senderID'] == userID) {
                    return MessageForwardRow(forwardID: documentSnapshot['receiverID'], title: documentSnapshot['title'], message: documentSnapshot['message'], messageID: documentSnapshot.id);
                  }

                  return Container();
                  }
                );
              } else {
                return const Text("No messages!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}

class MessageRecieveRow extends StatelessWidget {
  const MessageRecieveRow({super.key,
  required this.senderID,
  required this.title,
  required this.message,
  required this.messageID});

  final String senderID;
  final String title;
  final String message;
  final String messageID;
  
  void goToRead(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePage(
        senderID: senderID,
        receiverID: '',
        title: title,
        message: message,
        messageID: messageID
      )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUser(senderID),
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
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(title, textAlign: TextAlign.right,))),
                  Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.read_more), onPressed: () {goToRead(context);}))),
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
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(title, textAlign: TextAlign.right,))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.read_more), onPressed: () {goToRead(context);}))),
            ]
          );
        },
    );
  }
}

class MessageForwardRow extends StatelessWidget {
  const MessageForwardRow({super.key,
  required this.forwardID,
  required this.title,
  required this.message,
  required this.messageID});

  final String forwardID;
  final String title;
  final String message;
  final String messageID;

  void goToRead(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePage(
        senderID: '',
        receiverID: forwardID,
        title: title,
        message: message,
        messageID: messageID
      )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GalleryStoreService.instance.getUser(forwardID),
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
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(title, textAlign: TextAlign.right,))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.read_more), onPressed: () {goToRead(context);}))),
                ]
              ),
              onTap: () => {goToProfileTemp(context, forwardID)}
              );
            } else {
              return const Text("No user here!");
            }
          }
 
          return Row(
                children: <Widget>[
                            const AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                            const Expanded(child: Padding(padding: EdgeInsets.all(1.5), child: Text('Blank User', textAlign: TextAlign.left,))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: Text(title, textAlign: TextAlign.right,))),
                            Expanded(child: Padding(padding: const EdgeInsets.all(1.5), child: IconButton(icon: const Icon(Icons.read_more), onPressed: () {goToRead(context);}))),
                ]
              );
        },
    );
  }
}

class MessageUserRow extends StatelessWidget {
  const MessageUserRow({super.key,
  required this.userText,
  required this.userID});

  final String userText;
  final String userID;
  
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
              return 
              GestureDetector(
              child: Row(
                children: <Widget>[
                            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(1.5), child: Text(userText, textAlign: TextAlign.right,))),
                            AvatarImage(avatarSrc: snapshot.data!.avatar, size: 46.0, padding: 14.0),
                            Expanded(flex: 3, child: Padding(padding: const EdgeInsets.all(1.5), child: Text(snapshot.data!.username, textAlign: TextAlign.left,))),
                ]
              ),
              onTap: () => {goToProfileTemp(context, userID)}
              );
            } else {
              return const Text("No user here!");
            }
          }
 
          return Row(
                children: <Widget>[
                            Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(1.5), child: Text(userText, textAlign: TextAlign.right,))),
                            const AvatarImage(avatarSrc: '', size: 46.0, padding: 14.0),
                            const Expanded(flex: 3, child: Padding(padding: EdgeInsets.all(1.5), child: Text("Blank user", textAlign: TextAlign.left,))),
                ]
              );
        },
    );
  }
}

class MessageTitle extends StatelessWidget {
  const MessageTitle({super.key,
  required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text('Title: $title'));
  }
}

class Message extends StatelessWidget {
  const Message({super.key,
  required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(message));
  }
}

class MessageBottom extends StatelessWidget {
  const MessageBottom({super.key,
  required this.isUserReceiver,
  required this.messageID,
  required this.receiverID,
  required this.title
  });

  final bool isUserReceiver;
  final String messageID;
  final String receiverID;
  final String title;
  
  void _replyToUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComposeMessagePage(receiverID: receiverID, title: 're: $title')));
    
  }

  void _deleteMessage(BuildContext context) {
    //Navigator.push(
    //  context,
    //  MaterialPageRoute(builder: (context) => FriendsListPage(userID: userID)));
    Future<void> removeMessage() async {
      await GalleryStoreService.instance.deleteMessage(messageID);
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
              onPressed: () async {
                // Adding to provider
                await removeMessage();

                // Handle adding new goal
                Navigator.of(context).pop();
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
    return (isUserReceiver) ?
     Align(
        alignment: Alignment.bottomRight,
        child: Row(
      children: <Widget> [
        Padding(
      padding: const EdgeInsets.all(8.0), 
      child: IconButton(
          icon: const Icon(Icons.reply),
          onPressed: () => _replyToUser(context),
           )
          ),
          Padding(
      padding: const EdgeInsets.all(8.0), 
      child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteMessage(context),
           )
          )
        ]
      )
    )
    : 
    Align(
        alignment: Alignment.bottomRight,
        child: Row(
      children: <Widget> [
        Padding(
      padding: const EdgeInsets.all(8.0), 
      child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteMessage(context),
           )
          )
        ]
      )
    );
  }
}

class ComposeMessageForm extends StatefulWidget {
  const ComposeMessageForm({super.key,
  required this.senderID,
  required this.receiverID,
  required this.title});

  final String senderID;
  final String receiverID;
  final String title;

  @override
  State<ComposeMessageForm> createState() => MessageFormState();
}

class MessageFormState extends State<ComposeMessageForm> {
  List<String> textFieldsValue = List.empty(growable: true);
  final _composeMessageFormKey = GlobalKey<FormState>();

  Future<void> sendNewMessage() async {
    //confirm can make the submission
    if ((_composeMessageFormKey.currentState!.validate())) {
        print('submitting new entry...');

        String newMessageTitle = textFieldsValue[0];
        String newMessageBody = textFieldsValue[1];

        GalleryStoreService.instance.addMessage(widget.senderID, widget.receiverID, newMessageTitle, newMessageBody);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Invalid Message!')));
    }

    textFieldsValue = List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _composeMessageFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 600,
            child: 
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Message Title'
                ),

                maxLines: 1,
                minLines: 1,

                initialValue: widget.title,

                validator: (value){
                  print(value);
                  if (value == null || value.isEmpty) {
                    return 'Title empty!';
                  } else {
                    textFieldsValue.add(value);
                  }

                  return null;
                },
              ),
            )
          ),
          SizedBox(
            width: 600,
            child: 
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message Here'
                
              ),

              maxLines: 12,
              minLines: 1,

              validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Message empty!';
                  } else {
                    textFieldsValue.add(value);
                  }

                  return null;
                },
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: 
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: ElevatedButton(
              child: const Text('Send Message'),
              onPressed: () async {
                  await sendNewMessage();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
