import 'package:flutter/material.dart';

import '../database/storeService.dart';

//import '../pages/taskNestedPage.dart';

class taskCard extends StatefulWidget {
  const taskCard({super.key,
    required this.id,
    required this.index,
    required this.description,
    required this.isDone,
    required this.day,
    required this.startTime,
    required this.endTime
  });

  final String id;
  final int index;
  final String description;
  final bool isDone;

  final String day;
  final String startTime;
  final String endTime;

  @override
  State<taskCard> createState() => _taskCardState();
}

class _taskCardState extends State<taskCard> {
  _taskCardState();

  void _toNestedPage() {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NestedListPage(taskLink: widget.id)));

    */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.indigo[100],
            child: Row(
                children: [
            Padding (
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: const Icon(Icons.edit_calendar),
                  color: Colors.white,
                  tooltip: "Set Time",
                  onPressed: () {
                    //showCalendarDialog();
                    _toNestedPage();
                  }),
              ),
            ),
            Flexible (
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(39.0),
                ),
                child: CheckboxListTile (
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('${widget.index}) ${widget.description}',),
                    //value: globals.checkSwitches[widget.index],
                    value: widget.isDone,
                    onChanged: (bool? value) async {
                      bool toSet = value!;

                      await StoreService.instance.updateTaskCheck(widget.id, toSet);
                    }
                  )
          )),
          Padding (
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  tooltip: "Remove Task",
                  onPressed: () async {
                    await StoreService.instance.deleteTask(widget.id);
                }
              ),
            ),
          ),
        ]
      ),
    );
  }
}
