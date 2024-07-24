import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/styling.dart';
import '../widgets/messageContent.dart';

class MessagesListPage extends StatelessWidget {
  const MessagesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    //check if user ID the same as the current account
    String uid = FirebaseAuth.instance.currentUser!.uid;
    
    //assumed can only be accessed by the user anyways, not others
    return MessageListBody(userID: uid);
  }
}

class MessageListBody extends StatelessWidget {
  const MessageListBody({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: MessagesList(userID: userID),),
      ],
    );
  }
}

class MessagePage extends StatelessWidget {
  const MessagePage({super.key,
  required this.senderID,
  required this.receiverID,
  required this.title,
  required this.message,
  required this.messageID});

  final String senderID;
  final String receiverID;
  final String title;
  final String message;
  final String messageID;

  @override
  Widget build(BuildContext context) {
    //check if user ID the same as the current account
    String uid = FirebaseAuth.instance.currentUser!.uid;
    
    String finalSender = senderID;
    String finalReceiver = receiverID;

    if (finalSender.isEmpty) {
      finalSender = uid;
    }

    if (finalReceiver.isEmpty) {
      finalReceiver = uid;
    }

    //assumed can only be accessed by the user anyways, not others
    return Scaffold(
            appBar: AppBar(title: const Text('Messages', style: AppTextStyles.headline1),
                           backgroundColor: AppColors.appBarColor,
            ),
            body: MessageBody(senderID: finalSender,
                              receiverID: finalReceiver,
                              title: title,
                              message: message,
                              isUserReceiver: (uid == finalReceiver),
                              messageID: messageID)
    );
  }
}

class MessageBody extends StatelessWidget {
  const MessageBody({super.key,
  required this.senderID,
  required this.receiverID,
  required this.title,
  required this.message,
  required this.isUserReceiver,
  required this.messageID});

  final String senderID;
  final String receiverID;
  final String title;
  final String message;
  final bool isUserReceiver;
  final String messageID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
      Expanded(flex: 1, child: MessageUserRow(userID: senderID, userText: 'Sender: '),),
      Expanded(flex: 1, child: MessageUserRow(userID: receiverID, userText: 'Receiver: '),),
      Expanded(flex: 1, child: MessageTitle(title: title),),
      Expanded(flex: 5, child: Message(message: message),),
      Expanded(flex: 1, child: MessageBottom(isUserReceiver: isUserReceiver, messageID: messageID, receiverID: senderID, title: title),),
      ],
    );
  }
}

class ComposeMessagePage extends StatelessWidget {
  const ComposeMessagePage({super.key,
  required this.receiverID,
  required this.title});

  final String receiverID;
  final String title;

  @override
  Widget build(BuildContext context) {
    //check if user ID the same as the current account
    String uid = FirebaseAuth.instance.currentUser!.uid;

    //assumed can only be accessed by the user anyways, not others
    return Scaffold(
            appBar: AppBar(title: const Text('New Message', style: AppTextStyles.headline1),
                           backgroundColor: AppColors.appBarColor,
            ),
            body: ComposeMessageBody(
                              senderID: uid,
                              receiverID: receiverID,
                              title: title)
    );
  }
}

class ComposeMessageBody extends StatelessWidget {
  const ComposeMessageBody({super.key,
  required this.senderID,
  required this.receiverID,
  required this.title});

  final String senderID;
  final String receiverID;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
      Expanded(flex: 1, child: MessageUserRow(userID: receiverID, userText: 'Send to'),),
      Expanded(flex: 8, child: ComposeMessageForm(senderID: senderID, receiverID: receiverID, title: title),),
      ],
    );
  }
}

