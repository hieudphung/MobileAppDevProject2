import 'package:flutter/material.dart';
import '../database/storeService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/taskCard.dart';
import '../widgets/taskForm.dart';
import '../widgets/userBar.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
    Align(
      alignment: Alignment.topCenter,
      child: userBar(),
    ),
    const Expanded(
        flex: 7,
        child: 
          ListOfStuff(),
        ),
    const Flexible(
      flex: 1,
      child: SizedBox(height: 1),
    ),
    Align(
      alignment: Alignment.bottomCenter,
      child: taskForm(),
    ),
      ],
    );
  }
}

class ListOfStuff extends StatelessWidget {
  const ListOfStuff ({super.key});

  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
        stream: StoreService.instance.getSnapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {

            int docSize = streamSnapshot.data!.docs.length;
            int actualCount = 0;

            for (int i = 0; i < docSize; i++) {
              if (streamSnapshot.data!.docs[i]['userID'] == uid) {
                actualCount = actualCount + 1;
              }
            }

            if (docSize > 0 && actualCount > 0) {
              //FIGURE OUT LAST STUFF:
              //ADDING THE SECONDARY LIST

              int actualIndex = 0;

                return ListView.builder(
                  itemCount: docSize,
                  itemBuilder: (context, index) {

                    final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                    if (documentSnapshot['userID'] == uid) {
                      actualIndex = actualIndex + 1;

                      return taskCard(id: documentSnapshot.id, index: actualIndex,
                                      description: documentSnapshot['description'],
                                      isDone: documentSnapshot['isDone'],
                                      day: documentSnapshot['dayOfWeek'],
                                      startTime: documentSnapshot['startTime'],
                                      endTime: documentSnapshot['endTime']);
                    } else {
                      return Container();
                    }
                  },
              );

            } else {
              return const Align(
                alignment: Alignment.center,
                child: Text("No items here!"),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

