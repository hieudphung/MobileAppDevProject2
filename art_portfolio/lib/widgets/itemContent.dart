import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../database/galleryStoreService.dart';

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

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;

    if (creatorID == user.uid) {
      return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FavoriteCount(imageID: imageID),
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
                      FavoriteCount(imageID: imageID),
                    ],);
  }
}

class FavoriteCount extends StatelessWidget {
  const FavoriteCount({super.key,
  required this.imageID});

  final String imageID;

  void addToFavorites(BuildContext context, bool hasFavorite, String userID, String existingFavoriteID) async {
    if (hasFavorite) {
      //remove from favorites
      await GalleryStoreService.instance.deleteFavorite(existingFavoriteID);

    } else {
      //add to favorites
      await GalleryStoreService.instance.addFavorite(imageID, userID);
    }
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;

    return  StreamBuilder(
              stream: GalleryStoreService.instance.getFavoritesStream(imageID),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {

                if (streamSnapshot.hasData) {

                  int totalFavorites = streamSnapshot.data!.docs.length;
                  bool hasFavorite = false;
                  String existingID = '';

                  for (int i = 0; i < totalFavorites; i++) {
                    DocumentSnapshot snapshot = streamSnapshot.data!.docs[i];

                    if (snapshot['userID'] == currentUser.uid) {
                      hasFavorite = true;
                      existingID = snapshot.id;
                    }
                  }

                  return Row(
                  children: <Widget>[
                    IconButton(
                          icon: const Icon(Icons.favorite),
                          onPressed: () async => addToFavorites(context, hasFavorite, currentUser.uid, existingID)),
                    Text('$totalFavorites'),
                  ],);
                }

                return const Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Text('0'),
                  ],);
            });

                        
  }
}