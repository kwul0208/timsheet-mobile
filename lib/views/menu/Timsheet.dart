import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/AddTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:intl/intl.dart';

class Timesheet extends StatefulWidget {
  const Timesheet({super.key});

  @override
  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime.now();
  String dateForAdd = '';


  // data
  List<TimesheetModel>? _timesheet;
  Future<dynamic>? _futureTimesheet;

  @override
  void initState(){
    super.initState();

    // time now
    DateTime dt = DateTime.parse(DateTime.now().toString());
    String formattedDate = DateFormat("yyyy-MM-dd").format(dt);
    dateForAdd = formattedDate;
    _futureTimesheet = getTimesheet(formattedDate);
  }

  Future<void> _displaySecondView(Widget view) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => view));
        print(result);

    if (!mounted) return;

    if (result == dateForAdd) {
      Timer(Duration(milliseconds: 100), () {
        getTimesheet(result);
        print('reloaddd');
      });
    }
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
        automaticallyImplyLeading: false,
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
                  onDateSelected: (date){
                    String formattedDate = DateFormat("yyyy-MM-dd").format(date);                        
                    dateForAdd = formattedDate;
                    getTimesheet(formattedDate);

                  },
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder(
                future: _futureTimesheet,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Consumer<TimesheetState>(
                      builder: (context, data, _) {
                        print(data.refresh);
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 7, 
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: Config().primary,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text("Total Time", style: TextStyle(color: Config().subText),),
                                    ],
                                  ),
                                  Text("${Helper().formatedTime(time: _timesheet![0].time_duration)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 7, 
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: Config().primary,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text('Overtime', style: TextStyle(color: Config().subText))
                                    ],
                                  ),
                                  Text("00:00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  }else{
                    return SizedBox();
                  } 
                }
              ),
            ),
            FutureBuilder(
              future: _futureTimesheet,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<TimesheetState>(
                    builder: (context, data, _) {
                      print(data.refresh);
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _timesheet![0].timesheet.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimesheet(id: _timesheet![0].timesheet[i]['id'], date: _timesheet![0].timesheet[i]['date'], timeStart: _timesheet![0].timesheet[i]['timestart'], timeEnd: _timesheet![0].timesheet[i]['timefinish'], desc: _timesheet![0].timesheet[i]['description'],)));
                            },
                            child: ListTile(
                              shape: Border.all(color: Config().line, width: 0.5),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text("${_timesheet![0].timesheet[i]['description']}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                  Flexible(
                                    child: RichText(
                                    overflow: TextOverflow.ellipsis, // this will help add dots after maxLines
                                    maxLines: 2, // max lines after that dots comes
                                    // strutStyle: StrutStyle(fontSize: 12.0),
                                    text: TextSpan(
                                            style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                            text: "${_timesheet![0].timesheet[i]['description']}"
                                          ),
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Icon(Icons.timer_outlined, size: 16,color: Config().primary,),
                                      Text("${Helper().formatedTime(time: _timesheet![0].timesheet[i]['timeduration'])}", style: TextStyle(fontSize: 12, color: Config().subText),),
                                    ],
                                  )
                                ],
                              ),
                              subtitle: Text("${_timesheet![0].timesheet[i]['timestart']} - ${_timesheet![0].timesheet[i]['timefinish']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Config().primary),),
                              // trailing: Text("01:00h", sty),
                            ),
                          );
                        },
                      );
                    }
                  );
                }else{
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config().primary,
        child: Icon(Icons.add),
        onPressed: (){
          _displaySecondView(addTimsheet(date: dateForAdd));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => addTimsheet(date: dateForAdd)));
        },
      ),
    );
  }

  // API
  Future<void> getTimesheet(date)async{
    // _timesheet!.clear();

    _timesheet = await TimesheetApi.getDataCategory(context, date);
    Provider.of<TimesheetState>(context, listen: false).changeRefresh();


  }

}
