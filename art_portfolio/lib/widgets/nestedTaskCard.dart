import 'package:flutter/material.dart';

import '../database/storeService.dart';

class nestedTaskCard extends StatefulWidget {
  const nestedTaskCard({super.key,
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
  State<nestedTaskCard> createState() => _nestedTaskCardState();
}

class _nestedTaskCardState extends State<nestedTaskCard> {
  _nestedTaskCardState();

  void showCalendarDialog() {
    // For getting form data from pop-up
    Map data = {}; 

    //For saving data
    void saveData(String formField, dynamic formInput){data[formField] = formInput;}

    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Set Day and Time'),
        content: CalendarForm(keepingData: saveData,
                              initialDay: widget.day,
                              initialStartTime: widget.startTime,
                              initialEndTime: widget.endTime,),//Widget here,
        actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              OutlinedButton(
                onPressed: () {
                  //update it
                  print(data);
                  StoreService.instance.updateTaskTime(widget.id, data['dayOfWeek'], data['startTime'] ,data['endTime']);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Updating Schedule')),
                  );
                },
                child: const Text('Update'),
                ),
              ],
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.amber[100],
            child: Row(
                children: [
            Padding (
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: IconButton(
                  icon: const Icon(Icons.timer),
                  color: Colors.white,
                  tooltip: "Set Time",
                  onPressed: () {
                    showCalendarDialog();
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
                    subtitle: Text('${widget.day}\n ${widget.startTime} - ${widget.endTime}'),
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
                    await StoreService.instance.deleteTaskAndNested(widget.id);
                }
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class CalendarForm extends StatefulWidget {
  CalendarForm({
    required this.keepingData,
    required this.initialDay,
    required this.initialStartTime,
    required this.initialEndTime
  });

  final Function keepingData;
  final String initialDay;
  final String initialStartTime;
  final String initialEndTime;

  @override
  State<CalendarForm> createState() => _AddExpenditureFormState();
}

class _AddExpenditureFormState extends State<CalendarForm> {
  final _formKey = GlobalKey<FormState>();

  String _dayOfWeek = 'Monday';

  String startTime = '00:00';
  String startHours = '01';
  String startMinutes = '00';
  String startMil = 'AM';

  String endTime = '00:00';
  String endHours = '01';
  String endMinutes = '00';
  String endMil = 'AM';

  List<String> hours = List.empty(growable: true);
  List<String> minutes = List.empty(growable: true);
  List<String> mil = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    _dayOfWeek = widget.initialDay;

    startTime = widget.initialStartTime;
    endTime = widget.initialEndTime;

    widget.keepingData('dayOfWeek', _dayOfWeek);
    widget.keepingData('startTime', startTime);
    widget.keepingData('endTime', endTime);

    parseStartTime();
    parseEndTime();

    hours.add('01');
    hours.add('02');
    hours.add('03');
    hours.add('04');
    hours.add('05');
    hours.add('06');
    hours.add('07');
    hours.add('08');
    hours.add('09');
    hours.add('10');
    hours.add('11');
    hours.add('12');

    minutes.add('00');
    minutes.add('01');
    minutes.add('02');
    minutes.add('03');
    minutes.add('04');
    minutes.add('05');
    minutes.add('06');
    minutes.add('07');
    minutes.add('08');
    minutes.add('09');

    for (int i = 10; i < 60; i++) {
      minutes.add('$i');
    }

    mil.add('AM');
    mil.add('PM');
  }

  void parseStartTime() {
    startHours = widget.initialStartTime.substring(0,2);
    startMinutes = widget.initialStartTime.substring(3,5);
    startMil = widget.initialStartTime.substring(6,8);
  }

  void newStartTime() {
    startTime = '$startHours:$startMinutes $startMil';
    print(startTime);

    widget.keepingData('startTime', startTime);
  }

  void parseEndTime() {
    endHours = widget.initialEndTime.substring(0,2);
    endMinutes = widget.initialEndTime.substring(3,5);
    endMil = widget.initialEndTime.substring(6,8);
  }

  void newEndTime() {
    endTime = '$endHours:$endMinutes $endMil';
    print(endTime);

    widget.keepingData('endTime', endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //Setting day of week
            DropdownButtonFormField<String>(
            value: _dayOfWeek,
            items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),

            decoration: const InputDecoration(labelText: 'Day of Week'),
            onChanged: (value) {

              setState(() {
                _dayOfWeek = value!;
                widget.keepingData('dayOfWeek', _dayOfWeek);
              });
            },

          ),
          const Flexible(child: Text('Start Time')),
          Flexible(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: 
                      DropdownButtonFormField<String>(
                        value: startHours,
                        items: hours.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'Hour'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            startHours = value!;
                            newStartTime();
                          });
                        },

                      ),
                  ),
                  Expanded(
                    child: 
                    DropdownButtonFormField<String>(
                        value: startMinutes,
                        items: minutes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'Minutes'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            startMinutes = value!;
                            newStartTime();
                          });
                        },

                      ),
                    ),
                  Expanded(
                    child: 
                    DropdownButtonFormField<String>(
                        value: startMil,
                        items: mil.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'AM/PM'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            startMil = value!;
                            newStartTime();
                          });
                        },

                      ),
                    ),
                ]
              ),
          ),
          const Flexible(child: Text('End Time')),
          Flexible(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: 
                      DropdownButtonFormField<String>(
                        value: endHours,
                        items: hours.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'Hour'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            endHours = value!;
                            newEndTime();
                          });
                        },

                      ),
                  ),
                  Expanded(
                    child: 
                    DropdownButtonFormField<String>(
                        value: endMinutes,
                        items: minutes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'Minutes'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            endMinutes = value!;
                            newEndTime();
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: 
                    DropdownButtonFormField<String>(
                        value: endMil,
                        items: mil.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        decoration: const InputDecoration(labelText: 'AM/PM'),
                        onChanged: (value) {

                          setState(() {
                            //widget.keepingData('dayOfWeek', _dayOfWeek);
                            endMil = value!;
                            newEndTime();
                          });
                        },
                      ),
                    ),
                ]
              ),
          ),
        ],
      ),
    );
  }
}