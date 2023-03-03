import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CardRWD extends StatefulWidget {
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
    this.finish_hour,
    required this.wfh,
    this.secondView
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
  // data
  final List<WFHModel> wfh;
  final dynamic secondView;

  @override
  State<CardRWD> createState() => _CardRWDState();
}

class _CardRWDState extends State<CardRWD> {

    // state
  int? indexDetail;
  // status loading
  bool _isLoading = false;
  String _isStatus = 'false';
  // endStatus loading



  _showConfirm(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            // title: Text("Delete"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline),
                      Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  _isStatus == 'false'
                      ? Text("Are you sure want to delete your RWD?",style: TextStyle(fontSize: 16),)
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
                              : SizedBox(),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isStatus == 'false'
                        ? TextButton(
                            child: const Text('ok', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),
                            onPressed: () {
                              setState(() {
                                _isStatus = 'load';
                              });
                              deleteRWD(id).then((value) {
                                if (value['status'] == true) {
                                  setState(() {
                                    _isStatus = 'success';
                                  });
                                  Timer(Duration(seconds: 1), () {
                                    Navigator.pop(context);
                                    widget.wfh.removeWhere((e) => e.id == id);
                                    Provider.of<WFHState>(context,listen: false).changeRefresh();
                                    setState(() {
                                      _isStatus = 'false';
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Success"),
                                          duration: Duration(seconds: 4)
                                    ));
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                    _isStatus = 'false';
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Failed! try again later please."),
                                        duration: Duration(seconds: 4),
                                  ));
                                }
                              });
                            },
                          )
                        : SizedBox(),
                    _isStatus == 'false'
                        ? TextButton(
                            child: const Text('cancel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        : SizedBox(),
                    ],
                  )
                ],
              ),
              
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                DateTime dt = DateTime.parse("${widget.date}");
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
                                if (widget.duration == 'full_day') {
                                  return Text("Full Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                } else{
                                  return Text("Half Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                }
                              }
                            ),
                            SizedBox(width: 30,),
                            Builder(
                              builder: (context) {
                                if (widget.duration == "full_day") {
                                  return Text("-", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                }else{
                                  return Text("${widget.start_hour.toString().substring(0,5)} - ${widget.finish_hour.toString().substring(0,5)}");
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
                    widget.condition == 'overtime' ? Badge(title: "Ovetime", color: Config().blue2,) : SizedBox(),
                     Builder(
                       builder: (context) {
                        if(widget.status_id == 1){
                          return Badge(title: "Pending", color: Config().orangePallet,);
                        }else if (widget.status_id == 2) {
                          return Badge(title: "Approved", color: Config().blue2,);
                        } else if(widget.status_id == 3) {
                          return Badge(title: "Rejected", color: Config().redPallet,);
                        }else if(widget.status_id == 4){
                          return Badge(title: "Need Verification", color: Config().orangePallet,);
                        }else if(widget.status_id == 5){
                          return Badge(title: "Verified", color: Config().bgLock,);
                        }else if(widget.status_id == 6){
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
            Text("${widget.description}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Row(
                  children: [
                    widget.status_id == 1 ?
                    GestureDetector(
                      onTap: (){
                        _showConfirm(widget.id!);
                      },
                      child: Image.asset("assets/delete.png", scale: 2.3,)) : SizedBox(),
                    SizedBox(width: 4,),
                    widget.status_id == 1 || widget.status_id == 2 || widget.status_id == 4 ?
                    GestureDetector(
                      onTap: (){
                        widget.secondView(EditWFH(id: widget.id, date: widget.date, duration: widget.duration, condition: widget.condition, description: widget.description, startTime: widget.start_hour, finishTime: widget.finish_hour,));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => EditWFH(id: widget.id, date: widget.date, duration: widget.duration, condition: widget.condition, description: widget.description, startTime: widget.start_hour, finishTime: widget.finish_hour,)));
                      },
                      child: Image.asset("assets/edit_active.png", scale: 2.3,)) : SizedBox(),
                    SizedBox(width: 4,),
                    widget.status_id == 2 ?
                     Image.asset("assets/check_rounded.png", scale: 2,) : SizedBox(),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, SlideRightRoute(page: DetailWFH(id: widget.id, start_hour: widget.start_hour, finish_hour: widget.finish_hour, duration: widget.duration, condition: widget.condition, status_id: widget.status_id, is_overtime: widget.is_overtime,)));
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

  Future deleteRWD(id)async{
    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');
      
      var request = http.Request('DELETE', Uri.parse('http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/destroy/$id'));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        if (data['code'] == 200) {
          print('20000');
          return {"status": true, "message": "success"};
        }else{
          print('30000');
          return {"status": false, "message": "${data['code']}"};
        }
      }
      else {
          print('40000');
        return {"status": false, "message": "${response.reasonPhrase}"};
      }
    } catch (e) {
      print(e);
      print('50000');
      return {"status": false, "message": "${e}"};
    }
    
  }

}