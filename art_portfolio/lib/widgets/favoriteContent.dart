import 'package:art_portfolio/database/galleryStoreService.dart';
import 'package:art_portfolio/pages/favoritesListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'galleryItem.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList ({super.key,
  required this.userID,
  required this.limitedDisplay
  });

  final String userID;
  final bool limitedDisplay;

  @override
  Widget build(BuildContext context) {
    return (limitedDisplay) ? 
      StreamBuilder(
        stream: GalleryStoreService.instance.getUserFavoritesStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;
            
            if (docSize > 0) {
              return FavoriteGalleryPreview(index: 0, imageID: streamSnapshot.data!.docs[0]['imageID']);
            } else {
              return const Text("No favorites!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    : StreamBuilder(
        stream: GalleryStoreService.instance.getUserFavoritesStream(userID),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            int docSize = streamSnapshot.data!.docs.length;
            
            //check if need to search
            if (docSize > 0) {
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: docSize,
                  itemBuilder: (context, index) {
                    return FavoriteGalleryItem(index: index, imageID: streamSnapshot.data!.docs[index]['imageID']);
                  }
                );
              } else {
                return const Text("No favorites here!");
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

class MoreFavorites extends StatelessWidget {
  const MoreFavorites({super.key,
  required this.userID
  });

  final String userID;

  void _toFavoritesList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesListPage(userID: userID)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: const Icon(Icons.more),
          onPressed: () => _toFavoritesList(context),
        )
      )
    );
  }
}