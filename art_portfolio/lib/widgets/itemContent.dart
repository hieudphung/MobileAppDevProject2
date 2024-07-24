import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../common/styling.dart';
import '../database/galleryStoreService.dart';
import 'commentContent.dart';

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
        child: Text('Description: $imageDescription', style: AppTextStyles.bodyText),
      )
    );
  }
}

class SetButtons extends StatelessWidget {
  const SetButtons({super.key,
  required this.imageID,
  required this.creatorID,
  required this.oldTitle,
  required this.oldDescription
  });

  final String imageID;
  final String creatorID;

  final String oldTitle;
  final String oldDescription;

  void showImageEditDialog(BuildContext context) {
    //For holding data from form
    Map data = {};
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    //For sending to database
    Future<void> updateImage(bool validate, String title, String description) async {
      if (validate) {
        await GalleryStoreService.instance.updateImageDetails(imageID, title, description);
      }
        
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Image Details', style: AppTextStyles.bodyText),
          content: ImageEditDetailForm(keepingData: saveData, oldTitle: oldTitle, oldDescription: oldDescription),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: AppTextStyles.bodyText),
              onPressed: () {
                Navigator.of(context).pop();

                //goalFromForm = emptyGoal;
              },
            ),
            TextButton(
              child: const Text('Post', style: AppTextStyles.bodyText),
              onPressed: () async {
                // Adding to provider
                updateImage(data['validated'], data['title'], data['description']);

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
    User user = FirebaseAuth.instance.currentUser!;

    if (creatorID == user.uid) {
      return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Flexible(child: Padding(padding: EdgeInsets.fromLTRB(7.0,0.0,1.0,0), child: Text('By: '))),
                      Flexible(flex: 2, child: CommentUserRow(userID: creatorID)),
                      Flexible(child: FavoriteCount(imageID: imageID)),
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
                      const Flexible(child: Padding(padding: EdgeInsets.fromLTRB(7.0,0.0,1.0,0), child: Text('By: '))),
                      Flexible(flex: 2, child: CommentUserRow(userID: creatorID)),
                      Flexible(child: FavoriteCount(imageID: imageID)),
                    ],);
  }
}

class ImageEditDetailForm extends StatefulWidget {
  const ImageEditDetailForm({super.key,
  required this.keepingData,
  required this.oldTitle,
  required this.oldDescription});

  final Function keepingData;
  final String oldTitle;
  final String oldDescription;

  @override
  State<ImageEditDetailForm> createState() => _ImageEditDetailFormState();
}

class _ImageEditDetailFormState extends State<ImageEditDetailForm> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;
  
  String _title = '';
  String _description = '';

  void validate() {
    if (_title.isEmpty || _description.isEmpty) {
      validated = false;
    } else {
      validated = true;
    }
  }

  @override
  void initState() {
    super.initState();

    _title = widget.oldTitle;
    _description = widget.oldDescription;

    widget.keepingData('validated', validated);
    widget.keepingData('title', _title);
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
                labelText: 'Set the Title'
              ),

              maxLines: 1,
              minLines: 1,

              initialValue: widget.oldTitle,

              onChanged: (value) {
                _title = value;

                validate();

                setState(() {
                  widget.keepingData('validated', validated);
                  widget.keepingData('title', _title);
                  });
              },
            ),
          ),
          SizedBox(
            width: 600,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Set the Description'
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
                  });
              },
            ),
          ),
        ],
      ),
    );
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
                          color: (hasFavorite) ? Colors.pink[300] : Colors.grey[700],
                          onPressed: () async => addToFavorites(context, hasFavorite, currentUser.uid, existingID)),
                    Text('$totalFavorites', style: AppTextStyles.bodyText),
                  ],);
                }

                return const Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Text('0', style: AppTextStyles.bodyText),
                  ],);
            });

                        
  }
}