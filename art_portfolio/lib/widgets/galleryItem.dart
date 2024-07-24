import 'package:flutter/material.dart';

import '../common/styling.dart';
import '../database/galleryStoreService.dart';
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
            Text(galleryImage.imageName, style: AppTextStyles.bodyText)
          ]
        )
      ),
      onTap: (){
        _toGallery(context);
      }
    );
  }
}

class UserGalleryPreview extends StatelessWidget {
  const UserGalleryPreview({super.key,
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
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: <Widget> [
            Expanded(flex: 4, child: Image.network(galleryImage.src, height: 110.0)),
            Flexible(child: Text(galleryImage.imageName, style: AppTextStyles.bodyText))
          ]
        )
      ),
      onTap: (){
        _toGallery(context);
      }
    );
  }
}

class UserGalleryItem extends StatelessWidget {
  const UserGalleryItem({super.key,
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
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Column(
          children: <Widget> [
            Image.network(galleryImage.src, scale: 0.3, height: 110.0),
            Text(galleryImage.imageName, style: AppTextStyles.bodyText)
          ]
        )
      ),
      onTap: (){
        _toGallery(context);
      }
    );
  }
}

class FavoriteGalleryPreview extends StatelessWidget {
  const FavoriteGalleryPreview({super.key,
  required this.index,
  required this.imageID});

  final int index;
  final String imageID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <GalleryImage>(
      future: GalleryStoreService.instance.getGalleryItem(imageID), 
      builder: (BuildContext context, AsyncSnapshot<GalleryImage> snapshot) {
        if (snapshot.hasData) {
          return UserGalleryPreview(index: index, galleryImage: snapshot.data!);
        }

        return const Center(
          child: CircularProgressIndicator(),
        ); 
      }
    );
  }
}

class FavoriteGalleryItem extends StatelessWidget {
  const FavoriteGalleryItem({super.key,
  required this.index,
  required this.imageID});

  final int index;
  final String imageID;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder <GalleryImage>(
      future: GalleryStoreService.instance.getGalleryItem(imageID), 
      builder: (BuildContext context, AsyncSnapshot<GalleryImage> snapshot) {
        if (snapshot.hasData) {
          return UserGalleryItem(index: index, galleryImage: snapshot.data!);
        }

        return const Center(
          child: CircularProgressIndicator(),
        ); 
      }
    );
  }
}