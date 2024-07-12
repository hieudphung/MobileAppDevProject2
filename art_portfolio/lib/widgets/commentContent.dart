
import 'package:flutter/material.dart';

import '../database/galleryStoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentForm extends StatelessWidget {
  const CommentForm({super.key,
  required this.imageID});

  final String imageID;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(imageID)//Text('Description: $imageDescription'),
      )
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
            print('ayy');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
    );
  }
}

