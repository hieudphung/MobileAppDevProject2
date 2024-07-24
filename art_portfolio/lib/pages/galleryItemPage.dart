import 'package:flutter/material.dart';

import '../common/styling.dart';
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
            appBar: AppBar(title: Text(galleryItem.imageName, style: AppTextStyles.headline2),
                           backgroundColor: AppColors.appBarColor),
            body: GalleryItemBody(imageID: galleryItem.imageID, 
                                  src: galleryItem.src, 
                                  title: galleryItem.imageName,
                                  description: galleryItem.description,
                                  creatorID: galleryItem.userID));
  }
}

class GalleryItemBody extends StatelessWidget {
  const GalleryItemBody({super.key,
  required this.imageID,
  required this.src,
  required this.title,
  required this.description,
  required this.creatorID
  });

  final String imageID;
  final String src;
  final String title;
  final String description;
  final String creatorID;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    Expanded(flex: 4, child: ItemImage(imageSrc: src),),
    Expanded(flex: 1, child: SetButtons(imageID: imageID, creatorID: creatorID, oldTitle: title, oldDescription: description)),
    Expanded(flex: 1, child: DescriptionBox(imageDescription: description)),
    Expanded(flex: 1, child: CommentForm(imageID: imageID)),
    Expanded(flex: 5, child: CommentBox(imageID: imageID, creatorID: creatorID)),
      ],
    ));
  }
}