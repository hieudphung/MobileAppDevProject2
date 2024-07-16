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
    Expanded(
        flex: 9,
        child: 
          GalleryAndSearch(),
        ),
      ],
    );
  }
}

class GalleryAndSearch extends StatefulWidget {
  GalleryAndSearch({super.key});
  
  final _taskFormKey = GlobalKey<FormState>();

  @override
  State<GalleryAndSearch> createState() => GalleryAndSearchState();
}

class GalleryAndSearchState extends State<GalleryAndSearch> {
  String searchItem = '';
  String searchForm = '';

  @override
  Widget build(BuildContext context) {
    //Return the form and gallery list
    //gallery inside this so that when form updates state, search queue can be read by the gallery
    return Column(
      children: <Widget>[
        Flexible(
          child: Form(
            key: widget._taskFormKey,
            child: Row(
              children: <Widget>[   
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          searchForm = '';
                        } else {
                          searchForm = value;
                        }
                        return null;
                      },
                    ),
                  )
                ),
                Flexible(
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.search),
                    color: Colors.green,
                    tooltip: "Add Task",
                    onPressed: () {
                      if (widget._taskFormKey.currentState!.validate()) {
                        if (searchForm.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No search, getting recent...')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Searching...')),
                          );
                        }

                        setState((){
                          searchItem = searchForm;
                        });
                      }
                    },
                  ),
                ),
              ]
            )
          ),
        ),
        Expanded(child: GalleryList(searchString: searchItem)),
      ],
    );
  }
}

class GalleryList extends StatelessWidget {
  const GalleryList ({super.key,
  required this.searchString,
  });

  final String searchString;

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

            //check if need to search
            if (searchString.isNotEmpty) {
                for (int i = 0; i < docSize; i++) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[i];

                  String imageName = documentSnapshot['imageName'];
                      
                  if (imageName.toLowerCase().contains(searchString.toLowerCase())){
                    galleryImages.add(GalleryImage(imageID: documentSnapshot.id,
                                                userID: documentSnapshot['userID'], 
                                                src: documentSnapshot['src'],
                                                imageName: documentSnapshot['imageName'],
                                                description: documentSnapshot['description']));
                  }
                }
              } else {
                for (int i = 0; i < docSize; i++) {
                final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[i];
                      
                  galleryImages.add(GalleryImage(imageID: documentSnapshot.id,
                                              userID: documentSnapshot['userID'], 
                                              src: documentSnapshot['src'],
                                              imageName: documentSnapshot['imageName'],
                                              description: documentSnapshot['description']));
                }
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

