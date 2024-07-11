import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../database/storeService.dart';

class taskForm extends StatefulWidget{
  taskForm({super.key});

  final _taskFormKey = GlobalKey<FormState>();

  State<taskForm> createState() => _taskFormState();
}

class _taskFormState extends State<taskForm> {
  String taskDesc = '';
  String userID = FirebaseAuth.instance.currentUser!.uid;
  
  Future<void> _addTask() async {
      await StoreService.instance.addTask(taskDesc, userID);

      taskDesc = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._taskFormKey,
      child: Row(
        children: <Widget>[
          Flexible(
            child: IconButton.filledTonal(
              icon: const Icon(Icons.add),
              color: Colors.green,
              tooltip: "Add Task",
              onPressed: () async {
                if (widget._taskFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adding Task...')),
                  );
                  await _addTask();
                }
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Empty Task Entry!';
                  } else {
                    taskDesc = value;
                  }
                  return null;
                },
              ),
            )
          ),
        ]
      )
    );
  }
}