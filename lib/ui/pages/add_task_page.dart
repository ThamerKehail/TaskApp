import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late  DateTime _selectDate = DateTime.now();

  String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatedList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: primaryClr,
            ),
            onPressed: () => Get.back(),
          ),
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
              radius: 18,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Add Task",
                    style: headingStyle,
                  ),
                  InputField(
                    title: 'title',
                    note: 'Enter title here  ',
                    controller: _titleController,
                  ),
                  InputField(
                    title: 'Note',
                    note: 'Enter not here  ',
                    controller: _noteController,
                  ),

                  InputField(
                    title: "Date",
                    note: DateFormat.yMd().format(_selectDate),
                    widget: IconButton(
                      onPressed: () => _getDateFormUser(),
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          title: 'Start Time ',
                          note: _startTime,
                          widget: IconButton(
                            onPressed: () => _getTimeFormUser(isStartTime: true),
                            icon: const Icon(
                              Icons.access_time_rounded,
                            ),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: InputField(
                          title: 'End  Time ',
                          note: _endTime,
                          widget: IconButton(
                            onPressed: () =>
                                _getTimeFormUser(isStartTime: false),
                            icon: const Icon(
                              Icons.access_time_rounded,
                            ),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InputField(
                    title: 'Remind',
                    note: '$_selectedRemind minutes arly',
                    widget: Row(
                      children: [
                        DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          items: remindList
                              .map<DropdownMenuItem<String>>(
                                  (int value) => DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(
                                        '$value',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )))
                              .toList(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          style: subTitleStyle,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRemind = int.parse(newValue!);
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  InputField(
                    title: 'Repeat',
                    note: _selectedRepeat,
                    widget: Row(
                      children: [
                        DropdownButton(
                          dropdownColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          items: repeatedList
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )))
                              .toList(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          underline: Container(
                            height: 0,
                          ),
                          style: subTitleStyle,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRepeat = newValue!;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Color",
                            style: titleStyle,
                          ),
                          Wrap(
                            children: List<Widget>.generate(
                              3,
                              (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: CircleAvatar(
                                    child: _selectedColor == index
                                        ? const Icon(
                                            Icons.done,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                    backgroundColor: index == 0
                                        ? primaryClr
                                        : index == 1
                                            ? pinkClr
                                            : orangeClr,
                                    radius: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateDate();
                        },
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksTDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All field are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue,
          ));
    } else {
      print("########### SOMETHING BAD HAPPENED");
    }
  }

  _addTasksTDb() async {
    int value = await _taskController.addTask(
      task: Task(
          title: _titleController.text,
          note: _noteController.text,
          isCompleted: 0,
          date: DateFormat.yMd().format(_selectDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
          repeat: _selectedRepeat),
    );
    print('$value');
  }

  _getDateFormUser() async{
   DateTime?_pickedDate= await showDatePicker(
      context: context,
      initialDate: _selectDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2027),
    );
   if(_pickedDate!=null) {
     setState(() {
     _selectDate=_pickedDate;
   });
   }else {
     print('it \' s somthimg is wrong ');
   }
  }

  _getTimeFormUser({required bool isStartTime}) async{
    TimeOfDay?_pickedTime= await showTimePicker(
      context: context,
      initialTime: isStartTime?TimeOfDay.fromDateTime(DateTime.now())
          :TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),

    );
    String _formatedTime = _pickedTime!.format(context);
    if(isStartTime) {
      setState(() {
      _startTime=_formatedTime;
    });
    }
    if(!isStartTime) {setState(() {
      _endTime=_formatedTime;
    });

    } else {
      print("time canceld");
    }
    if(_pickedTime!=null) {

    }else {
      print('it \' s somthimg is wrong ');
    }


  }
}
