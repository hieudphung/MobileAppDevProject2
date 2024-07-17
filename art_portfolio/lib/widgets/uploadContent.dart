import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/galleryImage.dart';
import 'package:art_portfolio/widgets/galleryItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../pages/uploadsListPage.dart';

class UserUploadsList extends StatelessWidget {
  const UserUploadsList ({super.key,
  required this.userID,
  required this.limitedDisplay, 
  required this.isUser
  });

  final String userID;
  final bool limitedDisplay;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return (limitedDisplay) ? 
      StreamBuilder(
        stream: GalleryStoreService.instance.getUserGalleryStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
            if (docSize > 0) {
              List<GalleryImage> galleryImages = List.empty(growable: true);

              for (int i = 0; i < docSize; i++) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[i];
                  
                    galleryImages.add(GalleryImage(imageID: documentSnapshot.id,
                                              userID: documentSnapshot['userID'], 
                                              src: documentSnapshot['src'],
                                              imageName: documentSnapshot['imageName'],
                                              description: documentSnapshot['description']));
                }

              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return Expanded( child: Row(
                  children: <Widget> 
                  [
                    Expanded(child: UserGalleryItem(index: 0, galleryImage: galleryImages[0])),
                  ]
              ));
            } else {
              return const Text("No images uploaded!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    : StreamBuilder(
        stream: GalleryStoreService.instance.getUserGalleryStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
            if (docSize > 0) {
              List<GalleryImage> galleryImages = List.empty(growable: true);

              for (int i = 0; i < docSize; i++) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[i];
                  
                    galleryImages.add(GalleryImage(imageID: documentSnapshot.id,
                                              userID: documentSnapshot['userID'], 
                                              src: documentSnapshot['src'],
                                              imageName: documentSnapshot['imageName'],
                                              description: documentSnapshot['description']));
              }

              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return 
                  MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return GalleryItem(index: index, galleryImage: galleryImages[index]);
                  }
                  );
            } else {
              return const Text("No images uploaded!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class UploadForm extends StatelessWidget {
  const UploadForm({super.key, required String userID});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}

class MoreUploads extends StatelessWidget {
  const MoreUploads({super.key,
  required this.userID
  });

  final String userID;

  void _toUploadList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadsListPage(userID: userID)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () => _toUploadList(context),
        )
      )
    );
  }
}
