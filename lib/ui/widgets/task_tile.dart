import 'package:flutter/cupertino(1).dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
        color: _getBGClr(task.color),
        ),
        width: SizeConfig.screenWidth,
        height: MediaQuery.of(context).size.height*0.14,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SingleChildScrollView(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                Text(task.title!,style: GoogleFonts.lato(

                    textStyle:  const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold

                    )
                ),),
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Icon(Icons.access_time_rounded,
                  color: Colors.grey[200],
                    size: 18,
                  ),
                  const SizedBox(width: 12,),
                  Text("${task.startTime} - ${task.endTime}",
                    style: GoogleFonts.lato(

                      textStyle:  TextStyle(
                        color: Colors.grey[100],
                        fontSize: 13,

                      )
                  ),
                  )

                ],),
                const SizedBox(height: 12,),
                Text(task.note!,style: GoogleFonts.lato(

                    textStyle:  TextStyle(
                      color: Colors.grey[100],
                      fontSize: 15,

                    )
                ),),

              ],)),),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  width: 0.5,
                  color: Colors.grey[200]!.withOpacity(0.7),
                ),
              ),
               Center(
                 child: RotatedBox(quarterTurns: 3,
              child: Text(task.isCompleted==0?'TODO':'Completed',style: GoogleFonts.lato(

                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    )
              ),
              ),),
               )

            ],
          ),
        ),

      ),
    );
  }

  _getBGClr(int? color) {
    switch(color){
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;


    }
  }
}
