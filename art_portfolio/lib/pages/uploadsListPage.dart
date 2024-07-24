import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/styling.dart';
import '../widgets/uploadContent.dart';

class UploadsListPage extends StatelessWidget {
  const UploadsListPage({super.key,
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
            appBar: AppBar(title: const Text('Uploads List', style: AppTextStyles.headline2),
                           backgroundColor: const Color.fromARGB(255, 69, 188, 176),
                           bottom: const TabBar(
                            tabs: [
                              Tab(child: Text('Uploads')),
                              Tab(child: Text('New Upload')),
                            ],
                          ),
            ),
            body: TabBarView(
                  children: [
                    UploadsListBody(userID: userID, isUser: true),
                    UploadFormBody(userID: userID)
                  ]
            )
      ),
    ) :
    DefaultTabController(
            length: 1,
            child: Scaffold(
            appBar: AppBar(title: const Text('Uploads List', style: AppTextStyles.headline2),
                           backgroundColor: const Color.fromARGB(255, 69, 188, 176),
                           bottom: const TabBar(
                            tabs: [
                              Tab(child: Text('Uploads'))
                            ],
                          ),
            ),
            body: TabBarView(
                  children: [
                    UploadsListBody(userID: userID, isUser: false)
                  ]
            )
      ),
    ) 
    ;
  }
}

class UploadsListBody extends StatelessWidget {
  const UploadsListBody({super.key,
  required this.userID,
  required this.isUser
  });

  final String userID;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: UserUploadsList(userID: userID, limitedDisplay: false, isUser: isUser),),
      ],
    );
  }
}

class UploadFormBody extends StatelessWidget {
  const UploadFormBody({super.key,
  required this.userID,
  });

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Expanded(flex: 2, child: UploadForm(userID: userID)),
      ],
    );
  }
}

