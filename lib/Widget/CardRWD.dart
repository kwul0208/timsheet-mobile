import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';
import 'package:intl/intl.dart';

class CardRWD extends StatelessWidget {
  const CardRWD({
    Key? key,
    this.id,
    this.date,
    this.duration,
    this.description,
    this.condition,
    this.is_overtime,
    this.status_id,
    this.start_hour,
    this.finish_hour
  }) : super(key: key);
  
  final int ? id;
  final String? date;
  final String? duration;
  final String? description;
  final String? condition;
  final int? is_overtime;
  final int ? status_id;
  final String ? start_hour;
  final String ? finish_hour;
  

  @override
  Widget build(BuildContext context) {
    // String duration = "";
    // if (duration == "full_day") {
    //   duration = "Full Day";
    // }else{
    //   duration = "Half Day";
    // }
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Config().line, width: 3))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                DateTime dt = DateTime.parse("${date}");
                String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                return Text("${formattedDate}", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),);
              }
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
                            SizedBox(width: 30,),
                            Text("Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
                          ],
                        ),
                        Row(
                          children: [
                            Builder(
                              builder: (context) {
                                if (duration == 'full_day') {
                                  return Text("Full Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                } else{
                                  return Text("Half Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                }
                              }
                            ),
                            SizedBox(width: 30,),
                            Builder(
                              builder: (context) {
                                if (duration == "full_day") {
                                  return Text("-", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                }else{
                                  return Text("${start_hour.toString().substring(0,5)} - ${finish_hour.toString().substring(0,5)}");
                                }
                              }
                            ),
                          ],
                        )
                      ],
                    ),

                  ],
                ),
                Column(
                  children: [
                    is_overtime == 1 ? Badge(title: "Ovetime", color: Config().blue2,) : SizedBox(),
                     Builder(
                       builder: (context) {
                        if(status_id == 1){
                          return Badge(title: "Pending", color: Config().orangePallet,);
                        }else if (status_id == 2) {
                          return Badge(title: "Approved", color: Config().blue2,);
                        } else if(status_id == 3) {
                          return Badge(title: "Rejected", color: Config().redPallet,);
                        }else if(status_id == 4){
                          return Badge(title: "Need Verification", color: Config().orangePallet,);
                        }else if(status_id == 5){
                          return Badge(title: "Verified", color: Config().bgLock,);
                        }else if(status_id == 6){
                          return Badge(title: "Cancel", color: Color.fromRGBO(172, 172, 172, 1),);
                        }{
                          return SizedBox();
                        }
                       }
                     ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
            Text("$description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Row(
                  children: [
                    status_id == 1 ?
                    GestureDetector(
                      onTap: (){

                      },
                      child: Image.asset("assets/delete.png", scale: 2.3,)) : SizedBox(),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditWFH()));
                      },
                      child: Image.asset("assets/edit_active.png", scale: 2.3,)),
                    SizedBox(width: 4,),
                    status_id == 2 ?
                     Image.asset("assets/check_rounded.png", scale: 2,) : SizedBox(),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, SlideRightRoute(page: DetailWFH(id: id, start_hour: start_hour, finish_hour: finish_hour, duration: duration, condition: condition, status_id: status_id, is_overtime: is_overtime,)));
                      },
                      child: Image.asset("assets/arrow_right.png", scale: 1.9,)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}