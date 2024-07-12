import 'package:flutter/material.dart';

import '../model/galleryImage.dart';

import '../widgets/userBar.dart';
import '../widgets/itemContent.dart';
import '../widgets/commentContent.dart';

class GalleryItemPage extends StatelessWidget {
  const GalleryItemPage({super.key,
  required this.galleryItem});

  final GalleryImage galleryItem;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: Text(galleryItem.imageName),
                           backgroundColor: const Color.fromARGB(255, 79, 255, 240)),
            body: GalleryItemBody(imageID: galleryItem.imageID, src: galleryItem.src, description: galleryItem.description));
  }
}

class GalleryItemBody extends StatelessWidget {
  const GalleryItemBody({super.key,
  required this.imageID,
  required this.src,
  required this.description
  });

  final String imageID;
  final String src;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    Expanded(flex: 2, child: ItemImage(imageSrc: src),),
    Expanded(child: DescriptionBox(imageDescription: description)),
    Flexible(child: CommentForm(imageID: imageID)),
    Expanded(child: CommentBox(imageID: imageID)),
      ],
    );
  }
}