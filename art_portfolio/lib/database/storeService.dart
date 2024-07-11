import 'package:cloud_firestore/cloud_firestore.dart';

// Initialize Cloud Firestore and get a reference to the service
//const db = Firestore.getFirestore(app);

class StoreService {
  static final StoreService instance = StoreService._init();

  static CollectionReference? _tasks;
  static CollectionReference? _users;

  StoreService._init(){
    _tasks = FirebaseFirestore.instance.collection('testTasks');
    _users = FirebaseFirestore.instance.collection('users');
  }

  Future<CollectionReference> get tasks async {
    if (_tasks != null) return _tasks!;

    _tasks = await _getFirebaseTasks();
    return _tasks!;
  }

  Future _getFirebaseTasks() async {
    _tasks = FirebaseFirestore.instance.collection('testTasks');
  }

  Future<CollectionReference> get users async {
    if (_users != null) return _users!;

    _users = await _getFirebaseUsers();
    return _users!;
  }

  Future _getFirebaseUsers() async {
    _users = FirebaseFirestore.instance.collection('users');
  }

  Future<void> addTask(String description, String uid) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.add({"userID": uid, "taskLink": 'N/A',
                     "description": description, 
                     "isDone": false, "dayOfWeek": "Monday",
                     "startTime" : "01:00 AM",
                     "endTime" : "04:00 PM"});
  }

  Future<void> addNestedTask(String description, String taskid) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.add({"userID": 'N/A', "taskLink": taskid,
                     "description": description, 
                     "isDone": false, "dayOfWeek": "Monday",
                     "startTime" : "01:00 AM",
                     "endTime" : "04:00 PM"});
  }

  Stream<QuerySnapshot<Object?>> getSnapshots() async* {
    CollectionReference tasks = await instance.tasks;

    Stream<QuerySnapshot<Object?>> snapshots = tasks.snapshots();

    yield* snapshots;
  }

  Future<void> updateTaskTime(String? id, String dayOfWeek, String startTime, String endTime) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.doc(id).update({
      "dayOfWeek": dayOfWeek,
      "startTime": startTime,
      "endTime": endTime
    });
  }

  Future<void> updateTaskCheck(String? id, bool check) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.doc(id).update({
      "isDone": check,
    });
  }

  Future<void> deleteTask(String? id) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.doc(id).delete();
  }

  Future<void> deleteTaskAndNested(String? id) async {
    CollectionReference tasks = await instance.tasks;

    await tasks.doc(id).delete();

    //also delete tasks if linked
    tasks.where('taskLink', isEqualTo: id).get().then((value) => {
      //value.delete();
      value.docs.forEach((snapshot){
        snapshot.reference.delete();
      })
    },);
  }

  Future<bool> checkUserExists(String? uid) async {
    CollectionReference users = await instance.users;

    bool userExists = false;

    try {
      var doc = await users.doc(uid).get();
      userExists = doc.exists;
      
    } catch (e) {
      throw e;
    }

    return userExists;
  }

  Future<void> addUser(String uid) async {
    CollectionReference users = await instance.users;

    await users.add({"userID": uid});

    //print('aaaaaaaaaaaaaaaa ${newUser.id}');

    /*
    await users.doc(newUser.id).collection('userTasks').add(
        {"description": "Account created!", 
          "isDone": false, "dayOfWeek": "Monday",
          "startTime" : "00:00:00",
          "endTime" : "04:00:00"
        }
      );
    */
  }
}