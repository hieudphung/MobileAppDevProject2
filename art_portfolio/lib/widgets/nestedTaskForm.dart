import 'package:flutter/material.dart';

import '../database/storeService.dart';

class nestedTaskForm extends StatefulWidget{
  nestedTaskForm({super.key,
  required this.taskLink});

  final String taskLink;

  final _taskFormKey = GlobalKey<FormState>();

  State<nestedTaskForm> createState() => _nestedTaskFormState();
}

class _nestedTaskFormState extends State<nestedTaskForm> {
  String taskDesc = '';

  Future<void> _addNestedTask() async {
      await StoreService.instance.addNestedTask(taskDesc, widget.taskLink);

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
              color: const Color.fromARGB(255, 76, 175, 137),
              tooltip: "Add Task",
              onPressed: () async {
                if (widget._taskFormKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adding Nested Task...')),
                  );
                  await _addNestedTask();
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
                    return 'Empty Nested Task Entry!';
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