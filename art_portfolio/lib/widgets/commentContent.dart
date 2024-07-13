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

  void addCommentDialog(BuildContext context) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> postComment(bool validate, String comment) async {
      User user = FirebaseAuth.instance.currentUser!;

      if (validate) {
        await GalleryStoreService.instance.addComment(user.uid, imageID, comment);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave a Comment'),
          content: CommentPostForm(keepingData: saveData, oldText: ''),
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
                postComment(data['validated'], data['comment']);

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
            addCommentDialog(context);
          }
        )
        //Text('Description: $imageDescription'),
    );
  }
}

class CommentPostForm extends StatefulWidget {
  const CommentPostForm({super.key,
  required this.keepingData,
  required this.oldText});

  final Function keepingData;
  final String oldText;

  @override
  State<CommentPostForm> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPostForm> {
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

    _comment = widget.oldText;

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

              initialValue: widget.oldText,

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
  required this.imageID,
  required this.creatorID});

  final String imageID;
  final String creatorID;
  
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

                return CommentCard(comment: commentToCard, creatorID: creatorID);
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
    required this.creatorID,
  });

  final Comment comment;
  final String creatorID;

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;


    void editCommentDialog(BuildContext context) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> postComment(String editedComment) async {
      await GalleryStoreService.instance.updateComment(comment.id, editedComment);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Comment'),
          content: CommentPostForm(keepingData: saveData, oldText: comment.comment),
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

  void deleteCommentDialog(BuildContext context) {
    //For sending to database
    Future<void> deleteComment() async {
      await GalleryStoreService.instance.deleteComment(comment.id);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this comment?'),
          //content: CommentPostForm(keepingData: ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                // Adding to provider
                deleteComment();

                // Handle adding new goal
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


    //Get the user before building
    return FutureBuilder <UserGalleryInfo>(
      future: GalleryStoreService.instance.getUser(comment.userID),
      builder: (BuildContext context, AsyncSnapshot<UserGalleryInfo> userComment) {
        if (userComment.hasData) {

          UserGalleryInfo userInfo = userComment.data!;

          //also check whether or not the user ID is the same as the token, or if user ID is the same as the image creator's ID, to show
          if (currentUser.uid == comment.userID) {
            return Card(
              child: 
              Column(
                children: <Widget>[
                    Text('${userInfo.username}: ${comment.comment}'),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editCommentDialog(context),),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteCommentDialog(context),)
                    ],),
                ]
              )
            );

            //Under a creator's work
          } else if (currentUser.uid == creatorID) {
            return Card(
              child: 
              Column(
                children: <Widget>[
                  Text('${userInfo.username}: ${comment.comment}'),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteCommentDialog(context),)
                    ],),
                ]
              )
            );
          } else {
            return Card(
              child: 
              Column(
                children: <Widget>[
                  Text('${userInfo.username}: ${comment.comment}'),
                ]
              )
            );
          }
        }

        return const Text('Loading comment...');
      }
    ); 
  }
}