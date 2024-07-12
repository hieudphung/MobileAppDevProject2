import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ItemImage extends StatelessWidget {
  const ItemImage ({super.key,
  required this.imageSrc});

  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Image.network(imageSrc),
    );
  }
}

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key,
  required this.imageDescription});

  final String imageDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Description: $imageDescription'),
      )
    );
  }
}

class SetButtons extends StatelessWidget {
  const SetButtons({super.key,
  required this.imageID,
  required this.creatorID,
  });

  final String imageID;
  final String creatorID;

  void showImageEditDialog(BuildContext context) {

  }

  void addToFavorites(BuildContext context) {
    
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;

    if (creatorID == user.uid) {
      return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit_document),
                        onPressed: () => showImageEditDialog(context)),
                    ],);
    }

    //check if in favorites beforehand for toggling
    //will have to be a futurebuilder because have to check database if user has it in their favorites

        return Row(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () => addToFavorites(context))
                    ],);
  }
}