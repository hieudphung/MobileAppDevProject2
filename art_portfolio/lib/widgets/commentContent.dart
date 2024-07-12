import 'package:flutter/material.dart';

import '../model/comment.dart';
import '../model/user.dart';

import '../database/galleryStoreService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({super.key,
  required this.imageID});

  final String imageID;

  void _addCommentDialog(BuildContext context) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> postComment(String comment) async {
      User user = FirebaseAuth.instance.currentUser!;

      await GalleryStoreService.instance.addComment(user.uid, imageID, comment);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave a Comment'),
          content: CommentPostForm(keepingData: saveData),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Post'),
              onPressed: () async {
                // Adding to provider
                postComment(data['comment']);

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
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {
            _addCommentDialog(context);
          }
        )
        //Text('Description: $imageDescription'),
    );
  }
}

class CommentPostForm extends StatefulWidget {
  const CommentPostForm({super.key,
  required this.keepingData});

  final Function keepingData;

  @override
  State<CommentPostForm> createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<CommentPostForm> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;
  
  String _comment = '';

  void validate() {
    if (_comment.isEmpty) {
      validated = false;
    } else {
      validated = true;
    }
  }

  @override
  void initState() {
    super.initState();
  
    widget.keepingData('validated', validated);
    widget.keepingData('comment', _comment);
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
                border: OutlineInputBorder(),
                labelText: 'Say something...'
              ),

              maxLines: 6,
              minLines: 1,

              onChanged: (value) {
                _comment = value;

                validate();

                setState(() {
                  widget.keepingData('validated', validated);
                  widget.keepingData('comment', _comment);
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}






class CommentBox extends StatelessWidget {
  const CommentBox ({super.key,
  required this.imageID});

  final String imageID;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: 
        StreamBuilder(
        stream: GalleryStoreService.instance.getCommentStream(imageID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
           int docSize = streamSnapshot.data!.docs.length;

           if (docSize > 0) {
            return ListView.builder(
              itemCount: docSize,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                
                Comment commentToCard = Comment(id: documentSnapshot.id, userID: documentSnapshot['userID'], comment: documentSnapshot['comment']);

                return CommentCard(comment: commentToCard);
              }
            );
           } else {
            return const Text("No comments yet!");
           }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
    );
  }
}

class CommentCard extends StatelessWidget {
  const CommentCard({super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    //Get the user before building
    return FutureBuilder <UserGalleryInfo>(
      future: GalleryStoreService.instance.getUser(comment.userID),
      builder: (BuildContext context, AsyncSnapshot<UserGalleryInfo> user) {
        if (user.hasData) {

          UserGalleryInfo userInfo = user.data!;

          return Card(
            child: Text('${userInfo.username}: ${comment.comment}')
          );
        }

        return const Text('Loading comment...');
      }
    ); 
  }
}