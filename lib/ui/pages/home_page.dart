import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl(1).dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';

import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../size_config.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  void initState() {



    super.initState();
    _taskController.getTasks();


    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();

  }
  late NotifyHelper notifyHelper;



  DateTime _selected = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 24,
              color: Get.isDarkMode ? Colors.white : darkGreyClr,
            ),
            onPressed: () {
              setState(() {
                ThemeServices().switchTheme();
                // notifyHelper.displayNotification(
                //     title: "Theme changed ", body: "fgf");
                // notifyHelper.scheduledNotification();
              });
            },
          ),
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          actions:  [
            IconButton(
              icon: Icon(
                Icons.cleaning_services_outlined,
                size: 24,
                color: Get.isDarkMode? Colors.white:darkGreyClr,
                 ),
              onPressed: () {
                showDialog(context: context, builder: (BuildContext){

                  return AlertDialog(
                    title: const Text("Delete"),
                    content: const Text('Are you sure to delete all tasks ?'),
                    actions: [
                      InkWell(
                          child: Container(width: 80,height: 40,child: const Center(child: Text("Yes")),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),color: Colors.red[300]),),onTap:(){
                            Navigator.of(context).pop();
                        _taskController.deleteAllTasks();
                        notifyHelper.cancelAllNotification();
                        Get.snackbar("Cleaning", "All Task is Clean",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: pinkClr,
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.blue,
                            ));


                      } ,),
                      InkWell(child: Container(width: 80,height: 40,child: const Center(child: Text("No")),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),color: Colors.blue[300]),),onTap: (){
                        Navigator.of(context).pop();
                      },),

                    ],
                  );
                });
                // _taskController.deleteAllTasks();
                // notifyHelper.cancelAllNotification();
                // Get.snackbar("Cleaning", "All Task is Clean",
                //     snackPosition: SnackPosition.BOTTOM,
                //     backgroundColor: Colors.white,
                //     colorText: pinkClr,
                //     icon: const Icon(
                //       Icons.warning_amber_rounded,
                //       color: Colors.blue,
                //     ));

              },
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
              radius: 18,
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            _showTasks(),
          ],
        ));
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subheadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task ",
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 90,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle:  TextStyle(
          color: Get.isDarkMode?Colors.white:Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle:  TextStyle(
          color: Get.isDarkMode?Colors.white:Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle:  TextStyle(
          color: Get.isDarkMode?Colors.white:Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (newDate) {
          setState(() {
            _selected = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];
                if(task.repeat=='Daily'||task.date==DateFormat.yMd().format(_selected)||
                    (task.repeat=='Weekly'&& _selected.difference(DateFormat.yMd().parse(task.date!)).inDays%7==0)||
                    (task.repeat=='Monthly'&& DateFormat.yMd().parse(task.date!).day==_selected.day)


                ){
                  var hour = task.startTime.toString().split(':')[0];
                  var minutes = task.startTime.toString().split(':')[1];
                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);

                  notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[1]),
                    task,
                  );
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 1375),
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(
                            task: task,
                          ),
                        ),
                      ),
                    ),
                  );

                }else {
                  return Container();
                }


              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 370),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You don't have any tasks yet!\n Add new tasks to make your day",
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4.0),
        width: MediaQuery.of(context).size.width,
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.39,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Task Completed",
                    onTab: () {
                      notifyHelper.cancelNotification(task);


                      _taskController.markUsCompleted(task.id!);
                        Get.back();

                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: "Delete Completed",
                onTab: () {
                  notifyHelper.cancelNotification(task);

                  _taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red[300]!),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: "Cancel",
                onTab: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTab,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr,
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            )),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
