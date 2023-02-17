import 'dart:async';
import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerCardTImeseet.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/AddTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/DetailTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/views/pages/Timsheet/UnlockRequestTimesheet.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:draggable_fab/draggable_fab.dart';



class Timesheet extends StatefulWidget {
  const Timesheet({super.key});

  @override
  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  // state
  int? indexDetail;
  // status loading
  bool _isLoading = false;
  String _isStatus = 'false';
  // endStatus loading

  // is consultant
  String is_consultant = "1";

  String _scrollDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  DateTime _dateTime = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime.now();
  String dateForAdd = '';

  // data
  List<TimesheetModel>? _timesheet;
  Future<dynamic>? _futureTimesheet;

  @override
  void initState() {
    super.initState();

    // time now
    DateTime dt = DateTime.parse(DateTime.now().toString());
    String formattedDate = DateFormat("yyyy-MM-dd").format(dt);
    dateForAdd = formattedDate;
    _futureTimesheet = getTimesheet(formattedDate, false);
    isConsultant();
  }

  Future<void> isConsultant()async{
    final storage = new FlutterSecureStorage();
    is_consultant= (await storage.read(key: 'is_consultant'))!;
    print('is_consultant');
    print(is_consultant);
  }

  Future<void> _displaySecondView(Widget view) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => view));
    print('asd');
    print(result);
// setState(() {
//           _scrollDate = "2023-01-15";
//         });

    if (!mounted) return;
    print('result');
    print(result);
    if (result == dateForAdd) {
      Timer(Duration(milliseconds: 100), () {
        getTimesheet(result, true);
        print('reloaddd');
        setState(() {
          _scrollDate = dateForAdd;
        });
      });
    }
  }

  _showConfirm(int timesheet_id) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Delete"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _isStatus == 'false'
                      ? Text("Are You Sure?")
                      : _isStatus == 'load'
                          ? Center(child: CircularProgressIndicator())
                          : _isStatus == 'success'
                              ? Center(
                                  child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 50,
                                      color: Color.fromRGBO(47, 158, 95, 1),
                                    ),
                                    Text('Success')
                                  ],
                                ))
                              : SizedBox()
                ],
              ),
            ),
            actions: <Widget>[
              _isStatus == 'false'
                  ? TextButton(
                      child: const Text('ok'),
                      onPressed: () {
                        setState(() {
                          _isStatus = 'load';
                        });
                        deleteTimesheet(timesheet_id).then((value) {
                          if (value['status'] == true) {
                            setState(() {
                              _isStatus = 'success';
                            });
                            Timer(Duration(seconds: 1), () {
                              Navigator.pop(context);
                              _timesheet![0].timesheet.removeWhere((element) =>
                                  element['timesheet_id'] == timesheet_id);
                              Provider.of<TimesheetState>(context,
                                      listen: false)
                                  .changeRefresh();
                              setState(() {
                                _isStatus = 'false';
                              });
                            });
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Failed! try again later please."),
                            ));
                          }
                        });
                      },
                    )
                  : SizedBox(),
              _isStatus == 'false'
                  ? TextButton(
                      child: const Text('cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : SizedBox(),
            ],
          );
        });
      },
    );
  }

  _showDialogLocked(String val) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // title: Text("Locked"),
            contentPadding: EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline),
                      Text(
                        "Locked",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                      "${val}"),
                  Divider(),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    print(DateTime.parse(_scrollDate));
    print(DateTime(2023, 1, 20));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Config().primary,
        title: Text("Timesheet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: "Inter")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            CalendarTimeline(
              initialDate: DateTime.parse(_scrollDate),
              firstDate: DateTime(2022, 12, 01),
              lastDate: DateTime(2024, 01, 01),
              onDateSelected: (date) {
                String formattedDate = DateFormat("yyyy-MM-dd").format(date);
                print(dateForAdd);
                dateForAdd = formattedDate;
                getTimesheet(formattedDate, true);
                indexDetail = null;
              },
              leftMargin: 20,
              monthColor: Colors.black,
              dayColor: Colors.black,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Config().orangePallet,
              dotsColor: Color(0xFF333A47),
              // selectableDayPredicate: (date) => date.day != 23,
              // locale: 'en_ISO',
              showYears: false,
            ),
            Container(
              width: width,
              height: 10,
              color: Config().line,
            ),
            // -- alert lock
            FutureBuilder(
                future: _futureTimesheet,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Consumer<TimesheetState>(
                        builder: (context, data, _) {
                      // -- check loading
                      if (data.isLoading == false) {
                        // -- format date untuk relock date
                        String formattedDate = "";
                        if (_timesheet![0].relocked_date != null) {
                          DateTime dt = DateTime.parse("${_timesheet![0].relocked_date}");
                          formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                        }
                        // --  jika ada data
                        if(_timesheet![0].timesheet.length != 0){
                          if (_timesheet![0].status == "locked" || _timesheet![0].status == "unlock_request") {

                            // -- check relock date --
                            if(_timesheet![0].relocked_date == null){
                              // 1. check tanggal locknya == today ? lock : no
                              DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                              DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                              // -- unlock --
                              if(forlockDate.compareTo(forTodayDate) > 0){
                                return SizedBox();

                              // -- lock --
                              }else{
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Config().grey2,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.lock_outline,
                                          size: 26,
                                        ),
                                        Text(
                                          "Locked",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }else{

                              // -- check tanggal relock sudah exp belum
                              DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date} 23:00:00");
                              DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                              // -- unvalid/lock --
                              if(forRelockDate.compareTo(forTodayDate) < 0){
                                return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      width: width,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Config().grey2,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.lock_outline,
                                            size: 26,
                                          ),
                                          Text(
                                            "Locked",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                              // -- valid
                              }else { //if(forRelockDate.compareTo(forTodayDate) > 0)
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      width: width,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Config().bgLock,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_open_outlined,
                                                  size: 34,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 5,),
                                                Text("Unlocked", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),)
                                              ],
                                            ),
                                            Text("Will be locked at $formattedDate", style: TextStyle(color: Colors.white, fontSize: 15),)
                                        ],),
                                      ),
                                    ),
                                  );
                              }
                              
                            }
                          } else {
                            return SizedBox();
                          }

                        // jika tidak ada data
                        }else{
                          

                          return Center(
                            child: Column(
                              children: [
                                // check status locked
                                _timesheet![0].status == "locked" || _timesheet![0].status == "unlock_request" ?
                                  // kondisi masih ke lock
                                  _timesheet![0].relocked_date == null ? 
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        width: width,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Config().grey2,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lock_outline,
                                              size: 26,
                                            ),
                                            Text(
                                              "Locked",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ) 
                                    :
                                    // kodisi udah ke unlock
                                    Builder(
                                      builder: (context) {
                                        // -- check tanggal relock sudah exp belum
                                        DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date} 23:00:00");
                                        DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                        // -- unvalid --
                                        if(forRelockDate.compareTo(forTodayDate) < 0){
                                          return Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Container(
                                                width: width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Config().grey2,
                                                    borderRadius: BorderRadius.circular(10)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.lock_outline,
                                                      size: 26,
                                                    ),
                                                    Text(
                                                      "Locked",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                        // -- valid
                                        }else { //if(forRelockDate.compareTo(forTodayDate) > 0)
                                            return Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                width: width,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Config().bgLock,
                                                  borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            Icons.lock_open_outlined,
                                                            size: 34,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Text("Unlocked", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),)
                                                        ],
                                                      ),
                                                      Text("Will be locked at $formattedDate", style: TextStyle(color: Colors.white, fontSize: 15),)
                                                  ],),
                                                ),
                                              ),
                                            );
                                        }
                                      }
                                    )
                                    :
                                    // kondisi open
                                    // -- ada alert not complete
                                    Consumer<TimesheetState>(
                                      builder: (context, data,_) {
                                        // chack range date from today - date lock = today < 5hr = show
                                        DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                                        print(_timesheet![0].locked_date!);
                                        DateTime inputDate = DateTime.parse(_timesheet![0].locked_date!);
                                        String formattedDate = dateFormat.format(inputDate);
                                        DateTime lock_date = dateFormat.parse(formattedDate);

                                        DateTime today = DateTime.now();
                                        Duration difference = lock_date.difference(today);
                                        int totalDays = difference.inDays;
                                        if(totalDays <= 5){
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              width: width,
                                              decoration: BoxDecoration(
                                                color: Config().redPallet,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text("Your timesheet is incomplete.", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                    Text("Complete it immediatelly before locked on", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                    Text("${formattedDate}", style: TextStyle(color: Colors.white, fontSize: 15),),
                                                  ],
                                                ),
                                              ),
                                            ),);
                                        }else{
                                          return SizedBox();
                                        }
                                      }
                                    ),
                                    SizedBox(),
                                
                                Image.asset('assets/empty.jpg'),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: _timesheet![0].status == "open" ? Text(
                                    "Your timesheet for this date is empty.", 
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ) : Text(
                                    "Your timesheet for this date is empty, request for unlock to complete it.", 
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),                                
                                  ),
                                )
                              ],
                            )
                          );
                        }
                        // -- end check data
                      }else{
                         return Column(
                           children: [
                             ShimmerCardTImesheet(width: width),
                             ShimmerCardTImesheet(width: width),
                             ShimmerCardTImesheet(width: width),
                             ShimmerCardTImesheet(width: width),
                           ],
                         );
                      }


                    });
                  } else {
                    return SizedBox();
                  }
                }),
            
            // -- alert before lock
            FutureBuilder(
              future: _futureTimesheet,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<TimesheetState>(
                    builder: (context, data, _) {
                      // 1. check tanggal locknya == today ? lock : no
                      DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                      DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                      // forlockDate.compareTo(forTodayDate) > 0
                      if(_timesheet![0].status == "open" || forlockDate.compareTo(forTodayDate) > 0){
                        if (_timesheet![0].timesheet.length >= 1) {
                          int hours = _timesheet![0].oa_duration;
                          double check_hour = hours / 3600;
                          if(check_hour < 8.0){
                            DateTime dt = DateTime.parse("${_timesheet![0].locked_date}");
                            String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Config().redPallet,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Your timesheet is incomplete.", style: TextStyle(color: Colors.white, fontSize: 15),),
                                      Text("Complete it immediatelly before locked on", style: TextStyle(color: Colors.white, fontSize: 15),),
                                      Text("${formattedDate}", style: TextStyle(color: Colors.white, fontSize: 15),),
                                    ],
                                  ),
                                ),
                              ),
                            );  
                          }else{
                            return SizedBox();
                          }
                        }else{
                          return SizedBox();
                        }
                      }else{
                        return SizedBox();
                      }
                    }
                  );
                }else{
                  return SizedBox();
                }
              }
            ),
            
            // -- timesheet
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
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Container(
                                width: width,
                                // height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Color.fromARGB(
                                              255, 221, 221, 221),
                                          offset: Offset(0, 5))
                                    ] //
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_timesheet![0].timesheet[i]['tmode_name']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 10),
                                      // -- mode suport --
                                      _timesheet![0].timesheet[i]['tmode_id'] ==
                                              8
                                          ? Text(
                                              "to: ${_timesheet![0].timesheet[i]['support_to_employees_name']}",
                                              style: TextStyle(
                                                  color: Config().primary,
                                                  fontWeight: FontWeight.w500))
                                          : SizedBox(),
                                      // -- end --

                                      // -- mode chargeabble time --
                                      _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  23 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  22 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  19 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  15 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  17 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  16 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  21 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  20 ||
                                              _timesheet![0].timesheet[i]
                                                      ['tmode_id'] ==
                                                  18
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_timesheet![0].timesheet[i]['companies_name']}",
                                                  style: TextStyle(
                                                      color: Config().primary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "${_timesheet![0].timesheet[i]['service_name']}",
                                                  style:
                                                      TextStyle(),
                                                )
                                              ],
                                            )
                                          : SizedBox(),
                                      // -- end --

                                      // -- mode project --
                                      _timesheet![0].timesheet[i]['tmode_id'] ==
                                              14
                                          ? Text(
                                              "${_timesheet![0].timesheet[i]['project_name']}",
                                              style: TextStyle(
                                                  color: Config().primary,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : SizedBox(),
                                      // -- end --

                                      // -- mode training --
                                      _timesheet![0].timesheet[i]['tmode_id'] ==
                                              9
                                          ? Text(
                                              "${_timesheet![0].timesheet[i]['training_name']}",
                                              style: TextStyle(
                                                  color: Config().primary,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          : SizedBox(),
                                      // -- end --

                                      _timesheet![0].timesheet[i]['tmode_id'] ==
                                              14 ? SizedBox() : SizedBox(height: 10),
                                      // Text(
                                      //   "${_timesheet![0].timesheet[i]['description']}",
                                      //   style: TextStyle(
                                      //       color: Colors.black54,
                                      //       fontSize: 13),
                                      // ),
                                      // _name.length > 10 ? _name.substring(0, 10)+'...' : _name,
                                      Text("Description:"),
                                      indexDetail != i ? 
                                        Html(data: "${_timesheet![0].timesheet[i]['description'].length > 100 ? _timesheet![0].timesheet[i]['description'].substring(0, 90)+'...' : _timesheet![0].timesheet[i]['description'] }") 
                                        : 
                                        Html(data: "${_timesheet![0].timesheet[i]['description']}"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      indexDetail == i
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Inputed Date   : ${_timesheet![0].timesheet[i]['date_input']}",),
                                                Text("Inputed From  : ${_timesheet![0].timesheet[i]['input_from']}"),
                                                Text("Updated Date  : ${_timesheet![0].timesheet[i]['date_update']}"),
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset('assets/time.png', scale: 2,),
                                              SizedBox(width: 5),
                                              Text(
                                                "${_timesheet![0].timesheet[i]['timestart'].toString().substring(0, 5)} - ${_timesheet![0].timesheet[i]['timefinish'].toString().substring(0, 5)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    if (_timesheet![0].status == 'locked' || _timesheet![0].status == "unlock_request") {
                                                    if(_timesheet![0].relocked_date == null){
                                                      DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                                                      DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                                      if(forlockDate.compareTo(forTodayDate) > 0){
                                                        _showConfirm(_timesheet![0].timesheet[i]['timesheet_id']);
                                                      }else{
                                                        _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                                                      }
                                                    }else{
                                                      // -- check tanggal relock sudah exp belum
                                                      DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date} 23:00:00");
                                                      DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                                      // -- unvalid --
                                                      if(forRelockDate.compareTo(forTodayDate) < 0){
                                                        _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                                                      }else{
                                                        _showConfirm(_timesheet![0].timesheet[i]['timesheet_id']);
                                                      }
                                                    }
                                                  } else {
                                                    _showConfirm(_timesheet![0].timesheet[i]['timesheet_id']);
                                                  }
                                                  },
                                                  // child: Icon(
                                                  //   Icons.delete_forever,
                                                  //   color: Colors.red,
                                                  //   size: 30,
                                                  // )
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 6),
                                                    child: Image.asset("assets/delete.png", scale: 2,),
                                                  ),
                                                ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (_timesheet![0].status == 'locked' || _timesheet![0].status == "unlock_request") {
                                                    if(_timesheet![0].relocked_date == null){
                                                      DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                                                      DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                                      if(forlockDate.compareTo(forTodayDate) > 0){
                                                        setState(() {
                                                          _scrollDate = dateForAdd;
                                                        });
                                                        
                                                        Provider.of<TimesheetState>(context, listen: false).reset();
                                                        _displaySecondView(EditTimesheet(id: _timesheet![0].timesheet[i]
                                                              ['timesheet_id'],
                                                          date: _timesheet![0]
                                                              .timesheet[i]['date'],
                                                          timeStart: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['timestart'],
                                                          timeEnd: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['timefinish'],
                                                          desc: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['description'],
                                                          tmode_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['tmode_id'],
                                                          proposal_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['proposal_id'],
                                                          services_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['services_id'],
                                                          serviceused_id:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['serviceused_id'],
                                                          companies_name:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['companies_name'],
                                                          service_name: _timesheet![0]
                                                              .timesheet[i]
                                                                  ['service_name']
                                                              .toString(),
                                                          support_to_employees_id:
                                                              _timesheet![0]
                                                                      .timesheet[i][
                                                                  'support_to_employees_id'],
                                                          support_to_employees_name:
                                                              _timesheet![0]
                                                                      .timesheet[i][
                                                                  'support_to_employees_name'],
                                                          project_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['project_id'],
                                                          project_name: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['project_name'],
                                                          training_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['training_id'],
                                                          training_name:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['training_name'],
                                                          is_consultant: is_consultant,
                                                          work_from: _timesheet![0].work_from,
                                                        ));
                                                      }else{
                                                        _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                                                      }
                                                    }else{
                                                      // -- check tanggal relock sudah exp belum
                                                      DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date} 23:00:00");
                                                      DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                                      // -- unvalid --
                                                      if(forRelockDate.compareTo(forTodayDate) < 0){
                                                        _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                                                      }else{
                                                        setState(() {
                                                          _scrollDate = dateForAdd;
                                                        });
                                                        
                                                        Provider.of<TimesheetState>(context, listen: false).reset();
                                                        _displaySecondView(EditTimesheet(id: _timesheet![0].timesheet[i]
                                                              ['timesheet_id'],
                                                          date: _timesheet![0]
                                                              .timesheet[i]['date'],
                                                          timeStart: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['timestart'],
                                                          timeEnd: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['timefinish'],
                                                          desc: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['description'],
                                                          tmode_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['tmode_id'],
                                                          proposal_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['proposal_id'],
                                                          services_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['services_id'],
                                                          serviceused_id:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['serviceused_id'],
                                                          companies_name:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['companies_name'],
                                                          service_name: _timesheet![0]
                                                              .timesheet[i]
                                                                  ['service_name']
                                                              .toString(),
                                                          support_to_employees_id:
                                                              _timesheet![0]
                                                                      .timesheet[i][
                                                                  'support_to_employees_id'],
                                                          support_to_employees_name:
                                                              _timesheet![0]
                                                                      .timesheet[i][
                                                                  'support_to_employees_name'],
                                                          project_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['project_id'],
                                                          project_name: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['project_name'],
                                                          training_id: _timesheet![0]
                                                                  .timesheet[i]
                                                              ['training_id'],
                                                          training_name:
                                                              _timesheet![0]
                                                                      .timesheet[i]
                                                                  ['training_name'],
                                                          is_consultant: is_consultant,
                                                          work_from: _timesheet![0].work_from,
                                                        ));
                                                     
                                                      }
                                                    }
                                                  } else {
                                                    setState(() {
                                                      _scrollDate = dateForAdd;
                                                    });
                                                    
                                                    Provider.of<TimesheetState>(context, listen: false).reset();
                                                    _displaySecondView(EditTimesheet(id: _timesheet![0].timesheet[i]
                                                          ['timesheet_id'],
                                                      date: _timesheet![0]
                                                          .timesheet[i]['date'],
                                                      timeStart: _timesheet![0]
                                                              .timesheet[i]
                                                          ['timestart'],
                                                      timeEnd: _timesheet![0]
                                                              .timesheet[i]
                                                          ['timefinish'],
                                                      desc: _timesheet![0]
                                                              .timesheet[i]
                                                          ['description'],
                                                      tmode_id: _timesheet![0]
                                                              .timesheet[i]
                                                          ['tmode_id'],
                                                      proposal_id: _timesheet![0]
                                                              .timesheet[i]
                                                          ['proposal_id'],
                                                      services_id: _timesheet![0]
                                                              .timesheet[i]
                                                          ['services_id'],
                                                      serviceused_id:
                                                          _timesheet![0]
                                                                  .timesheet[i]
                                                              ['serviceused_id'],
                                                      companies_name:
                                                          _timesheet![0]
                                                                  .timesheet[i]
                                                              ['companies_name'],
                                                      service_name: _timesheet![0]
                                                          .timesheet[i]
                                                              ['service_name']
                                                          .toString(),
                                                      support_to_employees_id:
                                                          _timesheet![0]
                                                                  .timesheet[i][
                                                              'support_to_employees_id'],
                                                      support_to_employees_name:
                                                          _timesheet![0]
                                                                  .timesheet[i][
                                                              'support_to_employees_name'],
                                                      project_id: _timesheet![0]
                                                              .timesheet[i]
                                                          ['project_id'],
                                                      project_name: _timesheet![0]
                                                              .timesheet[i]
                                                          ['project_name'],
                                                      training_id: _timesheet![0]
                                                              .timesheet[i]
                                                          ['training_id'],
                                                      training_name:
                                                          _timesheet![0]
                                                                  .timesheet[i]
                                                              ['training_name'],
                                                      is_consultant: is_consultant,
                                                      work_from: _timesheet![0].work_from,
                                                    ));
                                                                                                    
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.orange,
                                                              width: 2)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                3.0),
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.orange,
                                                          size: 16,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      border: Border.all(
                                                          color:
                                                              Config().primary,
                                                          width: 2)),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        // setState(() {
                                                        if (indexDetail == i) {
                                                          indexDetail = null;
                                                        } else {
                                                          indexDetail = i;
                                                        }
                                                        Provider.of<TimesheetState>(
                                                                context,
                                                                listen: false)
                                                            .changeRefresh();
                                                        // });
                                                      },
                                                      child: indexDetail == i
                                                          ? Icon(
                                                              Icons
                                                                  .keyboard_arrow_up_rounded,
                                                              color: Config()
                                                                  .primary,
                                                              size: 22,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .keyboard_arrow_down_rounded,
                                                              color: Config()
                                                                  .primary,
                                                              size: 22,
                                                            )))
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    });
                  } else {
                    return Column(
                      children: [
                        ShimmerCardTImesheet(width: width),
                        ShimmerCardTImesheet(width: width),
                        ShimmerCardTImesheet(width: width),
                        ShimmerCardTImesheet(width: width),
                      ],
                    );
                  }
                }),
            // -- summary
            FutureBuilder(
              future: _futureTimesheet,
              builder: (BuildContext contect, AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<TimesheetState>(
                    builder: (context, data, _) {
                      if(_timesheet![0].timesheet.length >= 1){
                        
                          int seconds = _timesheet![0].oa_duration; // some number of seconds
                          Duration duration = Duration(seconds: seconds);
                          String formattedDurationTotalTime = duration.toString().split('.').first.padLeft(8, "0");

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("SUMMARY OF WORKING TIME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Container(
                                        width: width/1.6,
                                        // height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Chargeable Time", style: TextStyle(color: Colors.white,),),
                                        ),
                                      ),
                                      Container(
                                        width: width/3.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("5.00", style: TextStyle(color: Colors.white,),),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: width/1.6,
                                        // height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Daily Routine", style: TextStyle(color: Colors.white,),),
                                        ),
                                      ),
                                      Container(
                                        width: width/3.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("5.00", style: TextStyle(color: Colors.white,),),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: width/1.6,
                                        // height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Total Working Time", style: TextStyle(color: Colors.white,),),
                                        ),
                                      ),
                                      Container(
                                        width: width/3.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("${formattedDurationTotalTime.substring(0, 5)}", style: TextStyle(color: Colors.white,),),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Container(
                                        width: width/1.6,
                                        // height: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Total Over Time", style: TextStyle(color: Colors.white,),),
                                        ),
                                      ),
                                      Container(
                                        width: width/3.8,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("5.00", style: TextStyle(color: Colors.white,),),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }else{
                        return SizedBox();
                      }
                    }
                    );
                }else{
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FutureBuilder(
          future: _futureTimesheet,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<TimesheetState>(builder: (context, data, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Builder(
                      builder: (context) {
                        if(_timesheet![0].status == 'locked' || _timesheet![0].status == "unlock_request"){
                          DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                          DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                          if (forlockDate.compareTo(forTodayDate) > 0) {
                            return SizedBox();
                          }else{
                            return FloatingActionButton(
                              heroTag: "btn1",
                              backgroundColor: Config().bgLock,
                              child: Icon(
                                Icons.lock_open_outlined,
                                size: 28,
                              ),
                              onPressed: () {
                                if (_timesheet![0].status == 'locked') {
                                  if (_timesheet![0].relocked_date == null) {
                                    _displaySecondView(UnlockRequestTimesheet(date: dateForAdd,));
                                  } else{
                                    // -- check tanggal relock sudah exp belum
                                    DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date}");
                                    DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                                    // -- unvalid --
                                    if(forRelockDate.compareTo(forTodayDate) < 0){
                                      _displaySecondView(UnlockRequestTimesheet(date: dateForAdd,));
                                    }else{
                                      _showDialogLocked("Your Request has been approved. Now you can add your timesheet before ${_timesheet![0].relocked_date}");

                                    }
                                  }
                                }else if(_timesheet![0].status == 'unlock_request') {
                                  _showDialogLocked("Request has not been approved. Your unlocked request date : ${_timesheet![0].unlocked_request_date} (pending)");
                                }

                              });
                          }
                        }else{
                          return SizedBox();
                        }
                      }
                    ),
                    SizedBox(height: 10),
                    FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Config().primary,
                      child: Icon(Icons.add),
                      onPressed: () {
                        if (_timesheet![0].status == 'locked' || _timesheet![0].status == "unlock_request") {
                          if(_timesheet![0].relocked_date == null){
                            DateTime forlockDate = DateTime.parse("${_timesheet![0].locked_date} 23:00:00");
                          DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                          if (forlockDate.compareTo(forTodayDate) > 0) {
                            Provider.of<TimesheetState>(context, listen: false).reset();
                            setState(() {
                              _scrollDate = dateForAdd;
                            });
                            _displaySecondView(addTimsheet(date: dateForAdd, is_consultant: is_consultant, work_from: _timesheet![0].work_from,));
                          }else{
                            _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                          }
                          }else{
                            // -- check tanggal relock sudah exp belum
                            DateTime forRelockDate = DateTime.parse("${_timesheet![0].relocked_date} 23:00:00");
                            DateTime forTodayDate = DateTime.parse("${DateTime.now()}");
                            // -- unvalid --
                            if(forRelockDate.compareTo(forTodayDate) < 0){
                              _showDialogLocked("This timesheet is locked. Request for unlock if you want to add or update an activity in this timesheet");
                            }else{
                              Provider.of<TimesheetState>(context, listen: false).reset();
                              setState(() {
                                _scrollDate = dateForAdd;
                              });
                              _displaySecondView(addTimsheet(date: dateForAdd, is_consultant: is_consultant, work_from: _timesheet![0].work_from,));
                            }

                            }

                        } else {
                          Provider.of<TimesheetState>(context, listen: false).reset();
                          setState(() {
                            _scrollDate = dateForAdd;
                          });
                          _displaySecondView(addTimsheet(date: dateForAdd, is_consultant: is_consultant, work_from: _timesheet![0].work_from,));
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => addTimsheet(date: dateForAdd)));
                      },
                    ),
                  ],
                );
              });
            } else {
              return SizedBox();
            }
          }),
    );
  }

  // API
  Future<void> getTimesheet(date, load) async {
    // _timesheet!.clear();
    if (load == true) {
      _timesheet![0].timesheet.clear();
      Provider.of<TimesheetState>(context, listen: false).changeRefresh();
    }

    Provider.of<TimesheetState>(context, listen: false).changeIsLoading();
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');

    _timesheet = await TimesheetApi.getDataApi(context, date, employees_id!);
    print("timesheet");
    print(_timesheet);
    
    Provider.of<TimesheetState>(context, listen: false).changeIsLoading();

    Provider.of<TimesheetState>(context, listen: false).changeRefresh();
  }

  // ---------- API -----------
  String baseUrl = Config().url;
  Future deleteTimesheet(int timesheetId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('$baseUrl/mucnet_api/api/timesheet/delete'));
    request.body = json.encode({"timesheet_id": timesheetId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('y');
      print(await response.stream.bytesToString());
      return {"status": true, "message": "success"};
    } else {
      print('x');
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
      return {"status": true, "message": "${response.reasonPhrase}"};
    }
  }
}
