import "package:flutter/material.dart";
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';

// Date Input	:	23/01/2023 02:45:07
// Date	:	20/01/2023
// Time	:	08:00-09:00
// Duration	:	01:00 - Daily Routine
// Description	:	fix bug color (timesheet app)
// Revision Date	:	-

class DetailTimesheet extends StatelessWidget {
  const DetailTimesheet({super.key, required this.id, required this.date, required this.date_input,required this.timeStart, required this.timeEnd, required this.time_duration, required this.desc, required this.date_modified, required this.tmode_name});

  final int id;
  final String date;
  final String date_input;
  final String timeStart;
  final String timeEnd;
  final int time_duration;
  final String desc;
  final String date_modified;
  final String tmode_name;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Datail Timesheet",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.delete,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 1.5,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CardDetailTimesheet(title: "Date Input : ", value: "$date_input",),
                    CardDetailTimesheet(title: "Date : ", value: "$date",),
                    CardDetailTimesheet(title: "Duration :", value: "${Helper().formatedTime(time: time_duration)} - Daily Routine",),
                    CardDetailTimesheet(title: "Description	:", value: "$desc",),
                    CardDetailTimesheet(title: "Revision Date	:", value: "$date_modified",),
                  ]
                ),
                ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Config().primary,
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimesheet(id: id, date: date, desc: desc, timeStart: timeStart, timeEnd: timeEnd,)));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                           Text(
                            'Update',
                            style: TextStyle(fontSize: 24),
                          ),
                          Icon(Icons.navigate_next_outlined, size: 30,)
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

class CardDetailTimesheet extends StatelessWidget {
  const CardDetailTimesheet({
    Key? key,
    required this.title,
    required this.value
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Config().subText))),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w500),),
            Flexible(child: Text(value),),
          ],
        ),
      ),
    );
  }
}
