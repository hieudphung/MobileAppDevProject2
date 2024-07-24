import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/galleryImage.dart';
import '../model/user.dart';

// Initialize Cloud Firestore and get a reference to the service
//const db = Firestore.getFirestore(app);

class GalleryStoreService {
  static final GalleryStoreService instance = GalleryStoreService._init();

  static CollectionReference? _gallery;
  static CollectionReference? _comments;
  static CollectionReference? _users;
  static CollectionReference? _favorites;
  static CollectionReference? _friends;
  static CollectionReference? _friendRequests;
  static CollectionReference? _messages;

  GalleryStoreService._init(){
    _gallery = FirebaseFirestore.instance.collection('gallery');
    _comments = FirebaseFirestore.instance.collection('comments');
    _users = FirebaseFirestore.instance.collection('users');
    _favorites = FirebaseFirestore.instance.collection('favorites');
    _friends = FirebaseFirestore.instance.collection('friends');
    _friendRequests = FirebaseFirestore.instance.collection('friendRequests');
    _messages = FirebaseFirestore.instance.collection('messages');
  }

  Future<CollectionReference> get gallery async {
    if (_gallery != null) return _gallery!;

    _gallery = await _getGallery();
    return _gallery!;
  }

  Future _getGallery() async {
    _gallery = FirebaseFirestore.instance.collection('gallery');
  }

  Future<CollectionReference> get comments async {
    if (_comments != null) return _comments!;

    _comments = await _getComments();
    return _comments!;
  }

  Future _getComments() async {
    _comments = FirebaseFirestore.instance.collection('comments');
  }

  Future<CollectionReference> get users async {
    if (_users != null) return _users!;

    _users = await _getUsers();
    return _users!;
  }

  Future _getUsers() async {
    _users = FirebaseFirestore.instance.collection('users');
  }

  Future<CollectionReference> get favorites async {
    if (_favorites != null) return _favorites!;

    _favorites = await _getFavorites();
    return _favorites!;
  }

  Future _getFavorites() async {
    _favorites = FirebaseFirestore.instance.collection('favorites');
  }

  Future<CollectionReference> get friends async {
    if (_friends != null) return _friends!;

    _friends = await _getFriends();
    return _friends!;
  }

  Future _getFriends() async {
    _friends = FirebaseFirestore.instance.collection('friends');
  }

  Future<CollectionReference> get friendRequests async {
    if (_friendRequests != null) return _friendRequests!;

    _friendRequests = await _getFriendRequests();
    return _friendRequests!;
  }

  Future _getFriendRequests() async {
    _friendRequests = FirebaseFirestore.instance.collection('friendRequests');
  }

  Future<CollectionReference> get messages async {
    if (_messages != null) return _messages!;

    _messages = await _getMessages();
    return _messages!;
  }

  Future _getMessages() async {
    _messages = FirebaseFirestore.instance.collection('messages');
  }

  Future<void> addGalleryItem(String name, String description, String url, String userID) async {
    CollectionReference gallery = await instance.gallery;

    gallery.add({
      "imageName" : name,
      "description" : description,
      "src" : url,
      "userID" : userID
    });
  }

  Future<GalleryImage> getGalleryItem(String imageID) async {
    CollectionReference gallery = await instance.gallery;

    String returnID = imageID;
    String userID = '';
    String src = '';
    String imageName = '';
    String description = '';
    
    await gallery.doc(imageID).get().then(
      (document) {
        userID = document['userID'];
        src = document['src'];
        imageName = document['imageName'];
        description = document['description'];
      }
    );

    GalleryImage userToReturn = GalleryImage(imageID: returnID, src: src, userID: userID, imageName: imageName, description: description);
    
    return userToReturn;
  }

  Stream<QuerySnapshot<Object?>> getGalleryStream() async* {
    CollectionReference gallery = await instance.gallery;

    Stream<QuerySnapshot<Object?>> snapshots = gallery.snapshots();

    yield* snapshots;
  }

  Stream<QuerySnapshot<Object?>> getUserGalleryStream(String uid) async* {
    CollectionReference gallery = await instance.gallery;

    Stream<QuerySnapshot<Object?>> snapshots = gallery.where('userID', isEqualTo: uid).snapshots();

    yield* snapshots;
  }

  Future<void> updateImageDetails(String imageID, String title, String description) async {
    CollectionReference gallery = await instance.gallery;

    await gallery.doc(imageID).update({
      "imageName" : title,
      "description" : description
    });
  }

  Future<void> addComment(String uid, String imageID, String comment) async {
    CollectionReference comments = await instance.comments;

    await comments.add({"userID": uid, "imageID": imageID, "comment": comment});
  }

  Future<void> deleteComment(String commentID) async {
    CollectionReference comments = await instance.comments;

    await comments.doc(commentID).delete();
  }

  Future<void> updateComment(String commentID, String newComment) async {
    CollectionReference comments = await instance.comments;

    await comments.doc(commentID).update({
      "comment": newComment,
    });
  }
  
  Stream<QuerySnapshot<Object?>> getCommentStream(String imgID) async* {
    CollectionReference comments = await instance.comments;
    
    Stream<QuerySnapshot<Object?>> snapshots = comments.where('imageID', isEqualTo: imgID).snapshots();

    yield* snapshots;
  }

  Future<void> addFavorite(String imageID, String uid) async {
    CollectionReference favorites = await instance.favorites;

    await favorites.add({"userID": uid, "imageID": imageID});
  }

  Future<void> deleteFavorite(String favoriteID) async {
    CollectionReference favorites = await instance.favorites;

    await favorites.doc(favoriteID).delete();
  }

  Stream<QuerySnapshot<Object?>> getUserFavoritesStream(String userID) async* {
    CollectionReference favorites = await instance.favorites;
    
    Stream<QuerySnapshot<Object?>> snapshots = favorites.where('userID', isEqualTo: userID).snapshots();

    yield* snapshots;
  }

  Stream<QuerySnapshot<Object?>> getFavoritesStream(String imgID) async* {
    CollectionReference favorites = await instance.favorites;
    
    Stream<QuerySnapshot<Object?>> snapshots = favorites.where('imageID', isEqualTo: imgID).snapshots();

    yield* snapshots;
  }

  Future<void> addUser(String uid, String username) async {
    CollectionReference users = await instance.users;

    await users.add({"userID": uid, "username": username});
  }
  
  Future<UserGalleryInfo> getUser(String uid) async {
    CollectionReference users = await instance.users;

    var user = users.doc(uid);

    String returnID = '';
    String username = 'Invalid User';
    String avatarSrc = '';
    String description = 'This user doesn\'t exist!';

    await user.get().then((item) {
      returnID = item['userID'];
      username = item['username'];
      avatarSrc = item['avatarSrc'];
      description = item['about'];
    });

    UserGalleryInfo userToReturn = UserGalleryInfo(id: returnID, username: username, avatar: avatarSrc, description: description);
    
    return userToReturn;
  }

  Future<UserGalleryInfo> getUserByUserID(String uid) async {
    CollectionReference users = await instance.users;

    var query = users.where('userID', isEqualTo:uid);

    String returnID = '';
    String username = 'Invalid User';
    String avatarSrc = '';
    String description = 'This user doesn\'t exist!';

    await query.get().then((QuerySnapshot snapshot) {
      returnID = snapshot.docs.first.id;
      username = snapshot.docs.first['username'];
      avatarSrc = snapshot.docs.first['avatarSrc'];
      description = snapshot.docs.first['about'];
    });

    UserGalleryInfo userToReturn = UserGalleryInfo(id: returnID, username: username, avatar: avatarSrc, description: description);
    
    return userToReturn;
  }

  Future<void> updateUserDetails(String uid, String newAbout) async {
    CollectionReference users = await instance.users;

    //print('updating...');

    //should only return one, so taking first either way
    var userSearch = users.where('userID', isEqualTo:uid);

    await userSearch.get().then((snapshot) async => {
      await snapshot.docs.first.reference.update({
          "about": newAbout
      })
    },);
  }

  Stream<QuerySnapshot<Object?>> getUserlistStream(String username) async* {
    CollectionReference users = await instance.users;

    //print('updating...');

    //should only return one, so taking first either way
    var snapshots = users.snapshots();

    yield* snapshots;
  }

  Stream<QuerySnapshot<Object?>> getUserStream(String uid) async* {
    CollectionReference users = await instance.users;

    //should only return one, so taking first either way
    Stream<QuerySnapshot<Object?>> snapshots = users.where('userID', isEqualTo:uid).snapshots();

    yield* snapshots;
  }

  
  Future<void> addFriendLink(String userID, String otherUserID) async {
    CollectionReference friends = await instance.friends;

    await friends.add({"link": [userID, otherUserID]});
  }
  
  
  Future<bool> areUsersFriends(String userID, String otherUserID) async {
    CollectionReference friends = await instance.friends;

    bool areFriends = false;

    await friends.where(
    Filter.and(
      Filter('link', whereIn: [userID]),
      Filter('link', whereIn: [otherUserID])
    )).get().then(
      (value) {
        //enough to signify friend link exists
        //lazy implementation but still
        if (value.size > 0) {
          areFriends = true;
        }
      }
    );

    return areFriends;
  }

  Future<void> removeFriendLink(String friendLinkID) async {
    CollectionReference friends = await instance.friends;

    await friends.doc(friendLinkID).delete();
  }

  Stream<QuerySnapshot<Object?>> getUserFriends(String uid) async* {
    CollectionReference friends = await instance.friends;

    //print(uid);
    
    Stream<QuerySnapshot<Object?>> snapshots = friends.where('link', arrayContainsAny: [uid]).snapshots();

    yield* snapshots;
  }

  Future<void> addFriendRequest(String senderID, String receiverID) async {
    CollectionReference friendRequests = await instance.friendRequests;

    await friendRequests.add({
      "requestee" : senderID,
      "recipient" : receiverID
    });
  }

  Future<void> acceptFriendRequest(String requestID) async {
    CollectionReference friendRequests = await instance.friendRequests;

    await friendRequests.doc(requestID).get().then(
      (value) async {
        var data = value.data();
        //print(data as Map);
        Map mappedData = data as Map;

        addFriendLink(
          mappedData['requestee'],
          mappedData['recipient']
        );
      }
    );

    await friendRequests.doc(requestID).delete();
  }

  Future<void> deleteFriendRequest(String requestID) async {
    CollectionReference friendRequests = await instance.friendRequests;

    await friendRequests.doc(requestID).delete();
  }

  Stream<QuerySnapshot<Object?>> getFriendRequests(String uid) async* {
    CollectionReference friendRequests = await instance.friendRequests;

    //print(uid);

    //as long as friend request mentions user ID in either 
    Stream<QuerySnapshot<Object?>> snapshots = friendRequests.where(
    Filter.or(
      Filter("recipient", isEqualTo: uid),
      Filter("requestee", isEqualTo: uid)
    )).snapshots();

    yield* snapshots;
  }

  Future<void> addMessage(String uid, String forwardID, String title, String message) async {
    CollectionReference messages = await instance.messages;

    await messages.add({
      "senderID" : uid,
      "receiverID" : forwardID,
      "title" : title,
      "message" : message
    });
  }

  Future<void> deleteMessage(String messageID) async {
    CollectionReference messages = await instance.messages;

    await messages.doc(messageID).delete();
  }

  Stream<QuerySnapshot<Object?>> getUserMessagesStream(String uid) async* {
    CollectionReference messages = await instance.messages;
    
    //as long as friend request mentions user ID in either 
    Stream<QuerySnapshot<Object?>> snapshots = messages.where(
    Filter.or(
      Filter("receiverID", isEqualTo: uid),
      Filter("senderID", isEqualTo: uid)
    )).snapshots();

    yield* snapshots;
  }
}