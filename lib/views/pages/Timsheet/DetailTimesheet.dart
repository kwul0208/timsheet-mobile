import 'dart:async';
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/EditTimesheet.dart';
import 'package:http/http.dart' as http;

class DetailTimesheet extends StatefulWidget {
  const DetailTimesheet({super.key, required this.id, required this.date, required this.date_input,required this.timeStart, required this.timeEnd, required this.time_duration, required this.desc, required this.date_modified, required this.tmode_name, required this.tmode_id});

  final int id;
  final String date;
  final String date_input;
  final String timeStart;
  final String timeEnd;
  final int time_duration;
  final String desc;
  final String date_modified;
  final String tmode_name;
  final int tmode_id;

  @override
  State<DetailTimesheet> createState() => _DetailTimesheetState();
}

class _DetailTimesheetState extends State<DetailTimesheet> {
    // status loading
  bool _isLoading = false;
  String _isStatus = 'false';
  // endStatus loading


  _showConfirm (){
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
                      deleteTimesheet(widget.id).then((value){
                        if (value['status'] == true) {
                          setState(() {
                            _isStatus = 'success';
                          });
                          Timer(Duration(seconds: 1), (){
                            Navigator.pop(context);
                            Navigator.pop(context, widget.date);
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
                      // deleteProduct(widget.id.toString()).then((value) {
                      //   if (value['status'] == 200) {
                          // setState(() {
                          //   _isStatus = 'success';
                          // });
                          // Timer(Duration(seconds: 1), (){
                          //   Navigator.pop(context);
                          //   Navigator.pop(context, 'back');
                          // });
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(page: 3,)),);
                      //   } else {
                          // setState(() {
                          //   _isLoading = false;
                          // });
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("Gagal! Silahkan coba beberapa saat lagi"),
                          // ));
                      //   }
                      // });
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
  print(widget.tmode_id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Datail Timesheet",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        actions:  [
          GestureDetector(
            onTap: (){
              _showConfirm();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
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
                    CardDetailTimesheet(title: "Date Input : ", value: "${widget.date_input}",),
                    CardDetailTimesheet(title: "Date : ", value: "${widget.date}",),
                    CardDetailTimesheet(title: "Duration :", value: "${Helper().formatedTime(time: widget.time_duration)} - Daily Routine",),
                    CardDetailTimesheet(title: "Description	:", value: "${widget.desc}",),
                    CardDetailTimesheet(title: "Revision Date	:", value: "${widget.date_modified}",),
                  ]
                ),
                ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Config().primary,
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimesheet(id: widget.id, date: widget.date, desc: widget.desc, timeStart: widget.timeStart, timeEnd: widget.timeEnd, tmode_id: widget.tmode_id,)));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                           Text(
                            'Edit',
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
