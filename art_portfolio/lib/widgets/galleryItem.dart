import 'package:flutter/material.dart';

import '../model/galleryImage.dart';

import '../pages/galleryItemPage.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({super.key,
  required this.index,
  required this.galleryImage});

  final int index;
  final GalleryImage galleryImage;

  void _toGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GalleryItemPage(galleryItem: galleryImage)));
  }

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget> [
            Image.network(galleryImage.src, scale: 0.3),
            Text(galleryImage.imageName)
          ]
        )
      ),
      onTap: (){
        _toGallery(context);
      }
    );
  }
}