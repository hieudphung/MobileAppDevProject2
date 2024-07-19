import 'package:flutter/material.dart';
import '../database/galleryStoreService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/userItem.dart';
import '../widgets/userBar.dart';

class UserLookupPage extends StatelessWidget {
  const UserLookupPage({super.key});
  
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
        flex: 9,
        child: 
          UsersAndSearch(),
        ),
      ],
    );
  }
}

class UsersAndSearch extends StatefulWidget {
  const UsersAndSearch({super.key});

  @override
  State<UsersAndSearch> createState() => UsersAndSearchState();
}

class UsersAndSearchState extends State<UsersAndSearch> {
  String searchForm = '';
  final _userSearchFormKey = GlobalKey<FormState>();

  void doSearch() {
    if (_userSearchFormKey.currentState!.validate()) {
        if (searchForm.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No search, getting recent...')),
          );
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Searching...')),
            );
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    //Return the form and gallery list
    //gallery inside this so that when form updates state, search queue can be read by the gallery
    return Column(
      children: <Widget>[
        Flexible(
          child: Form(
            key: _userSearchFormKey,
            child: Row(
              children: <Widget>[   
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState((){
                            searchForm = '';
                          });
                        } else {
                          setState((){
                            searchForm = value;
                          });
                        }
                        return null;
                      },
                    ),
                  )
                ),

                Flexible(
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.search),
                    color: Colors.green,
                    tooltip: "Add Task",
                    onPressed: () {
                      doSearch();
                    },
                  ),
                ),
              ]
            )
          ),
        ),
        Expanded(child: UsersList(searchString: searchForm)),
      ],
    );
  }
}

class UsersList extends StatelessWidget {
  const UsersList ({super.key,
  required this.searchString,
  });

  final String searchString;

  @override
  Widget build(BuildContext context) {
    //String uid = FirebaseAuth.instance.currentUser!.uid;
    
    return StreamBuilder(
        stream: GalleryStoreService.instance.getUserlistStream(searchString),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            //streamSnapshot.data!;

            int docSize = streamSnapshot.data!.docs.length;

            if (searchString.isNotEmpty) {
              List<String> searchIDs = List.empty(growable:true);

              for (int i = 0; i < docSize; i++) {
                String currentName = streamSnapshot.data!.docs[i]['username']; 
                String currentID = streamSnapshot.data!.docs[i].id; 

                if (currentName.toLowerCase().contains(searchString.toLowerCase())) {
                  searchIDs.add(currentID);
                }
              }

              //docsize the same as gallery images size
              if (searchIDs.isNotEmpty) {
                //FIGURE OUT LAST STUFF:
                //ADDING THE SECONDARY LIST
                  return ListView.builder(
                    itemCount: searchIDs.length,
                    itemBuilder: (context, index) {
                      return UserRow(userID: searchIDs[index]);
                    }
                  );
              } else {
                return const Text("No users found!");
              }
            } else {
              if (docSize > 0) {
                //FIGURE OUT LAST STUFF:
                //ADDING THE SECONDARY LIST
                  return ListView.builder(
                    itemCount: docSize,
                    itemBuilder: (context, index) {
                      return UserRow(userID: streamSnapshot.data!.docs[index].id);
                    }
                  );
              } else {
                return const Text("No users found!");
              }
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }
}

