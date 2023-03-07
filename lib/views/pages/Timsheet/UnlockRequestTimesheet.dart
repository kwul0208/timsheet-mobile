import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UnlockRequestTimesheet extends StatefulWidget {
  const UnlockRequestTimesheet({super.key, this.date});
  final String? date;

  @override
  State<UnlockRequestTimesheet> createState() => _UnlockRequestTimesheetState();
}

class _UnlockRequestTimesheetState extends State<UnlockRequestTimesheet> {
  // state
  bool _load = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController reasonC = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    reasonC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse("${widget.date}");
    String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.black),
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset("assets/x.png", scale: 1.8,)),
            title: Text("Unlock Request Timesheet",
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
            elevation: 0,
            // centerTitle: true,
            actions: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Image.asset("assets/check.png", scale: 1.8,),
                ),
                onTap: () async{
                   if(_formKey.currentState!.validate()){
                    setState(() {
                      _load = true;
                    });
                    await postUnlockRequest(reasonC.text).then((value){
                      if (value['status'] == true) {
                        print('----------');
                        print(value['status']);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${value['message']}"),
                        ));
                        Navigator.pop(context, widget.date);
                      }else{
                        print('----------2');
                        print(value['status']);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${value['message']}"),
                        ));
                      }
                    });
                    setState(() {
                      _load = false;
                    });
                   }
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: width/1.8,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("${formattedDate}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: reasonC,
                    decoration: InputDecoration(
                      label: Text("Reason")
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "required";
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),  
        ),
        _load == true ? Container(
          width: width,
          height: height,
          color: Color.fromARGB(78, 0, 0, 0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SizedBox()
      ],
    );
  }

  // -- API -- 
  Future postUnlockRequest(reason)async{
    String baseUrl = Config().url;
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${baseUrl}/mucnet_api/api/timesheet-unlock-request/update'));

    request.body = json.encode({
      'date': widget.date,
      'employees_id': employees_id,
      'reason': reason
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      Map data = jsonDecode(x);
      print(data);
     if (data['status'] == "succcess") {
        return {"status": true, "message": "success"};
      }else{
          return {"status": false, "message": "$data"};
      }
    }
    else {
      var x = await response.stream.bytesToString();
      print(x);
      return {"status": false, "message": "${response.reasonPhrase}"};
    }
  }
}
