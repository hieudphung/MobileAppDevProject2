import 'dart:io';

import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/model/galleryImage.dart';
import 'package:art_portfolio/widgets/galleryItem.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:image_picker/image_picker.dart';

import '../common/styling.dart';
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
                return Expanded(child: UserGalleryPreview(index: 0, galleryImage: galleryImages[0]));
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

class UploadForm extends StatefulWidget {
  const UploadForm({super.key, required this.userID});

  final String userID;

  @override
  State<UploadForm> createState() => UploadFormState();
}

class UploadFormState extends State<UploadForm> {
  List<String> textFieldsValue = List.empty(growable: true);
  final _uploadFormKey = GlobalKey<FormState>();

  bool validated = false;

  File? galleryFile;
  final picker = ImagePicker();

  Image currentImage = Image.asset('assets/images/no_image.png', height: 300);
  
  Future<void> uploadNewImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xfilePick = pickedFile;

    setState(() {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          currentImage = Image.file(galleryFile!, height: 300);
          //print('new image uploaded!');
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('New image uploaded!')));

        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('No image selected!')));
        }
    });
  }

  Future<void> submitNewArtwork() async {
    var galleryItemRef;
    var galleryItemImageRef;
    bool submitted = false;

    //confirm can make the submission
    if ((_uploadFormKey.currentState!.validate()) &&
       galleryFile != null) {
        String artworkName = textFieldsValue[0];
        String artworkDescription = textFieldsValue[1];

        print('submitting new entry...');

        final storage = FirebaseStorage.instance.ref();

        galleryItemRef = storage.child("$artworkName.jpg");
        galleryItemImageRef = storage.child("images/$artworkName.jpg");

        assert(galleryItemRef.name == galleryItemImageRef.name);
        assert(galleryItemRef.fullPath != galleryItemImageRef.fullPath);

        //var downloadURL = await galleryItemRef.getDownloadURL();
        
        print('aaaaaaaaa');
        //print(downloadURL);

        try {
          submitted = true;
          await galleryItemRef.putData(galleryFile!.readAsBytesSync());
        } catch (e) {
          submitted = false;
          print(e);
        }

        if (submitted) {
          String downloadURL = await galleryItemRef.getDownloadURL();
          print(artworkName);
          print(artworkDescription);
          print(downloadURL);
          print(widget.userID);

          //Now store in data table
          await GalleryStoreService.instance.addGalleryItem(artworkName, artworkDescription, downloadURL, widget.userID);
        }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Invalid Submission!')));
    }

    textFieldsValue = List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _uploadFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 600,
            child: 
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'New Title'
                ),

                maxLines: 1,
                minLines: 1,

                validator: (value){
                  print(value);
                  if (value == null || value.isEmpty) {
                    return 'Title empty!';
                  } else {
                    textFieldsValue.add(value);
                  }

                  return null;
                },
              ),
            )
          ),
          SizedBox(
            width: 600,
            child: 
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'New Description'
              ),

              maxLines: 6,
              minLines: 1,

              validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Description empty!';
                  } else {
                    textFieldsValue.add(value);
                  }

                  return null;
                },
              ),
            ),
          ),
          SizedBox(
            width: 300,
            child: 
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: ElevatedButton(
              child: const Text('Upload New Image', style: AppTextStyles.bodyText),
              onPressed: () async {
                  await uploadNewImage();
                },
              ),
            ),
          ),
          Expanded(
            child: 
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: currentImage
            ),
          ),
          SizedBox(
            width: 600,
            child: 
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: ElevatedButton(
              child: const Text('Submit New Artwork', style: AppTextStyles.bodyText),
              onPressed: () async {
                  await submitNewArtwork();
                },
              ),
            ),
          ),
        ],
      ),
    );
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
