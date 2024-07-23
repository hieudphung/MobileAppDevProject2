import 'package:flutter/material.dart';

import '../widgets/favoriteContent.dart';

class FavoritesListPage extends StatelessWidget {
  const FavoritesListPage({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
            length: 1,
            child: Scaffold(
            appBar: AppBar(title: const Text('Favorites'),
                           backgroundColor: const Color.fromARGB(255, 69, 188, 176),
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
      Expanded(flex: 2, child: FavoritesList(userID: userID, limitedDisplay: false)),
      ],
    );
  }
}