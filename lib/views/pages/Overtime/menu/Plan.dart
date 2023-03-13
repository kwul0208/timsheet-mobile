import 'dart:async';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/InputForModel.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/StatusModel.dart';
import 'package:timsheet_mobile/Models/Overtime/OTPlan/OTPlanApi.dart';
import 'package:timsheet_mobile/Models/Overtime/OTPlan/OTPlanModel.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerRWDList.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/AddOT.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/DetailOT.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/EditOT.dart';
import 'package:intl/intl.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  // data Dropdown
  InputFor? selectedUser;
  List<InputFor> users = <InputFor>[
    const InputFor("me", 'Me'),
    const InputFor("others", 'Others')
  ];
  StatusModel? selectedStatus;
  List<StatusModel> statuss = <StatusModel>[
    const StatusModel("pending", 'Pending'),
    const StatusModel("approved", 'Approved'),
    const StatusModel("rejected", 'Rejected')
  ];

  // -- data --
  List<OTPlanModel>? _ot;
  Future<dynamic>? _futureOt;
  String? _fullname;
  Future<dynamic>? _futureFullname;


  @override
  void initState() {
    super.initState();
    _futureFullname = getDataEmployee();
        // time now
    DateTime dt = DateTime.parse(DateTime.now().toString());
    String formattedDate = DateFormat("yyyy-MM-dd").format(dt);
    _futureOt = getDataOT(formattedDate, false);

    Future.delayed(Duration.zero).then((value){
      Provider.of<OvertimeState>(context, listen: false).changeError(false, '');
    });
  }

  
  Future getDataEmployee()async{
    final storage = new FlutterSecureStorage();
    _fullname = await storage.read(key: 'fullname');
    // _fullname = "Mohamad Trisna Indra";
    print(_fullname);
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
      DateTime dt = DateTime.parse(DateTime.now().toString());
      String formattedDate = DateFormat("yyyy-MM-dd").format(dt);
      if (result != null) {
      Timer(Duration(milliseconds: 100), () async {
        await getDataOT(formattedDate, false);
        print('reloaddd');
        setState(() {
          
        });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarTimeline(
              initialDate: DateTime.now(),
              firstDate: DateTime(2022, 12, 01),
              lastDate: DateTime(2024, 01, 01),
              onDateSelected: (date) {
                String formattedDate = DateFormat("yyyy-MM-dd").format(date);
                Provider.of<OvertimeState>(context, listen: false).changeError(false, '');
                getDataOT(formattedDate, true);
              },
              leftMargin: 20,
              monthColor: Colors.black,
              dayColor: Colors.black,
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
    
            // -- data Overtime --
            Consumer<OvertimeState>(
              builder: (context, data, _) {
                if (data.error == false) {
                  return FutureBuilder(
                    future: _futureOt,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Consumer<OvertimeState>(
                          builder: (context, data, _) {
                            if(data.isLoading == false){
                              if(_ot!.length >= 1){
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _ot!.length,
                                  itemBuilder: (context, i){
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Config().line, width: 2))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${_ot![i].employees_name}", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),),
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
                                                            Container(
                                                              width: width/2,
                                                              child: Text("Filled by", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),)
                                                            ),
                                                            SizedBox(width: 30,),
                                                            Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: width/2,
                                                              child: Text("${_ot![i].inputted_by}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),   
                                                            SizedBox(width: 30,),
                                                            Text("${_ot![i].timestart.toString().substring(0,5)} - ${ _ot![i].timefinish.toString().substring(0,5)}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                                                              
                                                          ],
                                                        )
                                                      ],
                                                    ),
      
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16,),
                                            FutureBuilder(
                                              future: _futureFullname,
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                  if (_ot![i].employees_name == _fullname) {
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568))),
                                                        Text("${_ot![i].description}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))
                                                      ],
                                                    );
                                                  }else{
                                                    return SizedBox();
                                                  }
                                                }else{
                                                  return SizedBox();
                                                }
                                              }
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }else{
                                return Column(
                                  children: [
                                    SizedBox(height: 30,),
                                    Image.asset('assets/empty2.jpg'),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Overtime Plan for this date is empty.", 
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ) 
                                    )
                                  ],
                                );
                              }
                            }else{
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return ShimmerRWDList(width: width);
                                },
                              );
                            }
                          }
                        );
                      }else{
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ShimmerRWDList(width: width);
                          },
                        );
                      }
                    }
                  );
                }else{
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset("assets/500.png"),
                      SizedBox(height: 30,),
                      Text("${data.message}. Please check your connection or contact IT Programmer", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                    ],
                  );
                }
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config().primary2,
        child: Icon(Icons.add),
        onPressed: (){
          // Provider.of<TimesheetState>(context, listen: false).reset();
          _displaySecondView(AddOT());
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddOT()));
        },
            ),
    );
  }

  // -- API --
  Future<void> getDataOT(date, load)async{
    await Future.delayed(Duration.zero);
    if (load == true) {
      if (_ot != null) {
        _ot!.clear();
      }
      Provider.of<OvertimeState>(context, listen: false).changeRefresh();
    }

    Provider.of<OvertimeState>(context, listen: false).changeIsLoading(true);

    _ot = await OTPlanApi.getDataApi(context, date);
    print(_ot);

    Provider.of<OvertimeState>(context, listen: false).changeIsLoading(false);

    Provider.of<OvertimeState>(context, listen: false).changeRefresh();
  }

}
