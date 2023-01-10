import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/AddTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';

class Timesheet extends StatefulWidget {
  const Timesheet({super.key});

  @override
  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime.now();

  @override
  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Config().primary,
        title: Text("Timsheet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            CalendarTimeline(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022, 12, 01),
                  lastDate: DateTime(2024, 01, 01),
                  onDateSelected: (date) => print(date),
                  leftMargin: 20,
                  monthColor: Colors.blueGrey,
                  dayColor: Colors.teal[200],
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: Color(0xFF333A47),
                  selectableDayPredicate: (date) => date.day != 23,
                  // locale: 'en_ISO',
                  showYears: false,
                ),
            Container(
              width: width,
              height: 10,
              color: Config().line,
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimesheet()));
                  },
                  child: ListTile(
                    shape: Border.all(color: Config().line, width: 0.5),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mengerjakan Tugas $index", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 16,color: Config().primary,),
                            Text("01:00h", style: TextStyle(fontSize: 12, color: Config().subText),),
                          ],
                        )
                      ],
                    ),
                    subtitle: Text("08:00 - 09:00", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Config().primary),),
                    // trailing: Text("01:00h", sty),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config().primary,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => addTimsheet()));
        },
      ),
    );
  }
}
