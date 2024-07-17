import 'package:art_portfolio/widgets/friendContent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesListPage extends StatelessWidget {
  const FavoritesListPage({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
            length: 1,
            child: Scaffold(
            appBar: AppBar(title: const Text('Friend\'s List'),
                           backgroundColor: Color.fromARGB(255, 79, 255, 158),
                           bottom: const TabBar(
                            tabs: [
                              Tab(child: Text('Favorites')),
                            ],
                          ),
            ),
            body: TabBarView(
                  children: [
                    FavoritesListBody(userID: userID),
                  ]
            )
      ),
    );
  }
}

class FavoritesListBody extends StatelessWidget {
  const FavoritesListBody({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: FavoritesGallery(userID: userID),),
      ],
    );
  }
}