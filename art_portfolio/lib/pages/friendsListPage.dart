import 'package:art_portfolio/widgets/friendContent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key,
  required this.userID});

  final String userID;

  @override
  Widget build(BuildContext context) {
    //check if user ID the same as the current account
    String uid = FirebaseAuth.instance.currentUser!.uid;
    
    return (uid == userID) ?
          DefaultTabController(
            length: 2,
            child: Scaffold(
            appBar: AppBar(title: const Text('Friend\'s List'),
                           backgroundColor: const Color.fromARGB(255, 79, 255, 240),
                           bottom: const TabBar(
                            tabs: [
                              Tab(child: Text('Friends')),
                              Tab(child: Text('Requests')),
                            ],
                          ),
            ),
            body: TabBarView(
                  children: [
                    FriendsListBody(userID: userID),
                    RequestListBody(userID: userID)
                  ]
            )
      ),
    ) :
    DefaultTabController(
            length: 1,
            child: Scaffold(
            appBar: AppBar(title: const Text('Friend\'s List'),
                           backgroundColor: const Color.fromARGB(255, 79, 255, 240),
                           bottom: const TabBar(
                            tabs: [
                              Tab(child: Text('Friends'))
                            ],
                          ),
            ),
            body: TabBarView(
                  children: [
                    FriendsListBody(userID: userID)
                  ]
            )
      ),
    ) 
    ;
  }
}

class FriendsListBody extends StatelessWidget {
  const FriendsListBody({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: UserFriendsList(userID: userID, limitedDisplay: false),),
      ],
    );
  }
}

class RequestListBody extends StatelessWidget {
  const RequestListBody({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: FriendRequestList(userID: userID),),
      ],
    );
  }
}