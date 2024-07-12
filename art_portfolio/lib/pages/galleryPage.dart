import 'package:flutter/material.dart';
import '../database/galleryStoreService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/galleryItem.dart';
import '../widgets/userBar.dart';

import '../model/galleryImage.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    const Expanded(
        flex: 8,
        child: 
          ListOfStuff(),
        ),
      ],
    );
  }
}

class ListOfStuff extends StatelessWidget {
  const ListOfStuff ({super.key});

  @override
  Widget build(BuildContext context) {
    //String uid = FirebaseAuth.instance.currentUser!.uid;
    
    return StreamBuilder(
        stream: GalleryStoreService.instance.getGalleryStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
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

            //docsize the same as gallery images size
            if (galleryImages.isNotEmpty) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return GalleryItem(index: index, galleryImage: galleryImages[index]);
                }
              );
            } else {
              return const Text("No images here!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
    
  }
}

