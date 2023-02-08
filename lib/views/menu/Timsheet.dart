import 'dart:async';
import 'dart:convert';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetApi.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/AddTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/DetailTimesheet.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

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

  String _scrollDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

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
        getTimesheet(result);
        print('reloaddd');
        setState(() {
          _scrollDate = dateForAdd;
        });
      });
    }
  }

  _showConfirm (int timesheet_id){
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Hapus"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      _isStatus == 'false' ? Text("Are You Sure?") :
                        _isStatus == 'load' ?
                        Center(
                          child: CircularProgressIndicator()) :
                          _isStatus == 'success' ?
                          Center(
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, size: 50, color: Color.fromRGBO(47, 158, 95, 1),),
                              Text('Berhasil')
                            ],
                          )) : SizedBox()
                    ],
                  ),
                ),
                actions: <Widget>[
                _isStatus == 'false' ?
                  TextButton(
                    child: const Text('ok'),
                    onPressed: () {
                      setState(() {
                        _isStatus = 'load';
                      });
                      deleteTimesheet(timesheet_id).then((value){
                        if (value['status'] == true) {
                          setState(() {
                            _isStatus = 'success';
                          });
                          Timer(Duration(seconds: 1), (){
                            Navigator.pop(context);
                             _timesheet![0].timesheet.removeWhere((element) => element['timesheet_id'] == timesheet_id);
                            Provider.of<TimesheetState>(context, listen: false).changeRefresh();
                            setState((){
                            _isStatus = 'false';

                            });
                          });
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Gagal! Silahkan coba beberapa saat lagi"),
                          ));
                        }
                      });
                    },
                  ) : SizedBox(),
                _isStatus == 'false' ?
                 TextButton(
                  child: const Text('batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ) : SizedBox(),
              ],
              );

            }
          );
      },
    );
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
        title: Text("Timesheet"),
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
                  onDateSelected: (date){
                    String formattedDate = DateFormat("yyyy-MM-dd").format(date);
                    print(dateForAdd);                        
                    dateForAdd = formattedDate;
                    getTimesheet(formattedDate);

                  },
                  leftMargin: 20,
                  monthColor: Colors.blueGrey,
                  dayColor: Colors.teal[200],
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.orange,
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
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: FutureBuilder(
            //     future: _futureTimesheet,
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         return Consumer<TimesheetState>(
            //           builder: (context, data, _) {
            //             print(data.refresh);
            //             return Container(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Container(
            //                             width: 7, 
            //                             height: 7,
            //                             decoration: BoxDecoration(
            //                               color: Config().primary,
            //                               borderRadius: BorderRadius.circular(5)
            //                             ),
            //                           ),
            //                           SizedBox(width: 5),
            //                           Text("Total Time", style: TextStyle(color: Config().subText),),
            //                         ],
            //                       ),
            //                       Text("${Helper().formatedTime(time: _timesheet![0].time_duration)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            //                     ],
            //                   ),
            //                   Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Container(
            //                             width: 7, 
            //                             height: 7,
            //                             decoration: BoxDecoration(
            //                               color: Config().primary,
            //                               borderRadius: BorderRadius.circular(5)
            //                             ),
            //                           ),
            //                           SizedBox(width: 5),
            //                           Text('Overtime', style: TextStyle(color: Config().subText))
            //                         ],
            //                       ),
            //                       Text("00:00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             );
            //           }
            //         );
            //       }else{
            //         return SizedBox();
            //       } 
            //     }
            //   ),
            // ),
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
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                            child: Container(
                              width: width,
                              // height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      color: Color.fromARGB(255, 221, 221, 221),
                                      offset: Offset(0, 5))
                                ] //
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${_timesheet![0].timesheet[i]['tmode_name']}", style: TextStyle(fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10),
                                    // -- mode suport --
                                      _timesheet![0].timesheet[i]['tmode_id'] == 8 ? Text("to: ${_timesheet![0].timesheet[i]['support_to_employees_name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500)) : SizedBox(),
                                    // -- end --

                                    // -- mode chargeabble time --
                                      _timesheet![0].timesheet[i]['tmode_id']  == 23 || _timesheet![0].timesheet[i]['tmode_id']  == 22 || _timesheet![0].timesheet[i]['tmode_id']  == 19 || _timesheet![0].timesheet[i]['tmode_id']  == 15 || _timesheet![0].timesheet[i]['tmode_id']  == 17 ||_timesheet![0].timesheet[i]['tmode_id']  == 16 || _timesheet![0].timesheet[i]['tmode_id']  == 21 || _timesheet![0].timesheet[i]['tmode_id']  == 20 || _timesheet![0].timesheet[i]['tmode_id']  == 18 ?
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${_timesheet![0].timesheet[i]['companies_name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500),),
                                          Text("${_timesheet![0].timesheet[i]['service_name']}", style: TextStyle(fontSize: 12),)
                                        ],
                                      ): SizedBox(),
                                    // -- end --

                                    // -- mode project --
                                       _timesheet![0].timesheet[i]['tmode_id'] == 14 ?
                                        Text("${_timesheet![0].timesheet[i]['project_name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500),) : SizedBox(),
                                    // -- end --

                                    // -- mode training --
                                       _timesheet![0].timesheet[i]['tmode_id'] == 9 ?
                                       Text("${_timesheet![0].timesheet[i]['training_name']}", style: TextStyle(color: Config().primary, fontWeight: FontWeight.w500),) : SizedBox(),
                                    // -- end --
                                    
                                    SizedBox(height: 10),
                                    Text("${_timesheet![0].timesheet[i]['description']}", style: TextStyle(color: Colors.black54, fontSize: 13),),
                                    SizedBox(height: 20,),
                                    indexDetail == i ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Inputed Date   : ${_timesheet![0].timesheet[i]['date_input']}", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                        // Text("Inputed From  : Meeting and Discussion System", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                        // Text("Updated Date  : 2023/02/07 10:00", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                      ],
                                    ) : SizedBox(),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.access_time),
                                            SizedBox(width: 5),
                                            Text("${_timesheet![0].timesheet[i]['timestart'].toString().substring(0, 5)} - ${_timesheet![0].timesheet[i]['timefinish'].toString().substring(0, 5)}", style: TextStyle(fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                print(_isLoading);
                                                _showConfirm(_timesheet![0].timesheet[i]['timesheet_id']);
                                              },
                                              child: Icon(Icons.delete_forever, color: Colors.red, size: 30,)
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  _scrollDate = dateForAdd;
                                                });
                                                print(_timesheet![0].timesheet[i]['id']);
                                                // print(_timesheet![0].timesheet);
                                                // return null;
                                                // this.proposal_id, this.services_id, this.serviceused_id, this.companies_name, this.service_name, this.support_to_employees_id, this.support_to_employees_name, this.project_id, this.project_name, this.training_id, this.training_name
                                                Provider.of<TimesheetState>(context, listen: false).reset();
                                                _displaySecondView(EditTimesheet(id: _timesheet![0].timesheet[i]['timesheet_id'], date: _timesheet![0].timesheet[i]['date'] ,timeStart: _timesheet![0].timesheet[i]['timestart'], timeEnd: _timesheet![0].timesheet[i]['timefinish'],desc: _timesheet![0].timesheet[i]['description'], tmode_id: _timesheet![0].timesheet[i]['tmode_id'], proposal_id: _timesheet![0].timesheet[i]['proposal_id'], services_id: _timesheet![0].timesheet[i]['services_id'], serviceused_id: _timesheet![0].timesheet[i]['serviceused_id'], companies_name: _timesheet![0].timesheet[i]['companies_name'], service_name: _timesheet![0].timesheet[i]['service_name'].toString(), support_to_employees_id: _timesheet![0].timesheet[i]['support_to_employees_id'], support_to_employees_name: _timesheet![0].timesheet[i]['support_to_employees_name'], project_id: _timesheet![0].timesheet[i]['project_id'], project_name: _timesheet![0].timesheet[i]['project_name'], training_id: _timesheet![0].timesheet[i]['training_id'], training_name: _timesheet![0].timesheet[i]['training_name'],));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.orange, width: 2)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Icon(Icons.edit, color: Colors.orange, size: 16,),
                                                )
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Config().primary, width: 2)
                                              ),
                                              child: GestureDetector(
                                                onTap: (){
                                                  // setState(() {
                                                    if (indexDetail == i) {
                                                      indexDetail = null;
                                                    }else{
                                                      indexDetail = i;
                                                    }
                                                    Provider.of<TimesheetState>(context, listen: false).changeRefresh();
                                                  // });
                                                },
                                                child: indexDetail == i ? Icon(Icons.keyboard_arrow_down_rounded, color: Config().primary, size: 22,): Icon(Icons.keyboard_arrow_up_rounded, color: Config().primary, size: 22,))
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
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
          setState(() {
            _scrollDate = dateForAdd;
          });
          _displaySecondView(addTimsheet(date: dateForAdd));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => addTimsheet(date: dateForAdd)));
        },
      ),
    );
  }

  // API
  Future<void> getTimesheet(date)async{
    // _timesheet!.clear();
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');
    
    _timesheet = await TimesheetApi.getDataApi(context, date, employees_id!);
    Provider.of<TimesheetState>(context, listen: false).changeRefresh();


  }

  // ---------- API -----------
  String baseUrl = Config().url;
  Future deleteTimesheet(int timesheetId)async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$baseUrl/mucnet_api/api/timesheet/delete'));
    request.body = json.encode({
      "timesheet_id": timesheetId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('y');
      print(await response.stream.bytesToString());
      return {"status": true, "message": "success"};
    }
    else {
      print('x');
      print(await response.stream.bytesToString());
      print(response.reasonPhrase);
      return {"status": true, "message": "${response.reasonPhrase}"};
    }
  }


}
