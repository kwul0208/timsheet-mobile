import 'dart:convert';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';

class CancelWFHForm extends StatefulWidget {
  const CancelWFHForm({super.key, this.id, this.wfh});
  final int? id;
  final List<WFHModel> ? wfh;


  @override
  State<CancelWFHForm> createState() => _CancelWFHFormState();
}

class _CancelWFHFormState extends State<CancelWFHForm> {
  // state
  bool _load = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController reasonC = TextEditingController();


  @override
  Widget build(BuildContext context) {
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
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text("Cancel RWD",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
            centerTitle: false,
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset("assets/x.png", scale: 2,)),
            actions: [
              GestureDetector(
                onTap: () async{
                  // print('ok');
                  if(_formKey.currentState!.validate()){
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    setState(() {
                      _load = true;
                    });
                    // await Future.delayed(Duration(seconds: 2));
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //       content: Text("Success"),
                    //     ));
                    //     Navigator.pop(context);
                    //     Navigator.pop(context);

                    await postCancelRWD(widget.id ,reasonC.text).then((value){
                      if (value['status'] == true) {
                        print('----------');
                        print(value['status']);
                        widget.wfh?.removeWhere((e) => e.id == widget.id);
                        Provider.of<WFHState>(context,listen: false).changeRefresh();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("${value['message']}"),
                        ));
                        Navigator.pop(context);
                        Navigator.pop(context);
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
                child: Image.asset("assets/check.png", scale: 1.8,)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
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
                    child: Text("12 Nov 2023", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                  ),
                ),
                SizedBox(height: 20,),
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
                ),
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

  Future postCancelRWD(id, reason)async{
    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');

      var headers = {
        'Content-Type': 'application/json'
      };
      
      var request = http.Request('PUT', Uri.parse('http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/cancel/$id'));

      request.body = json.encode({
        "reason_cancel": "$reason"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        print(data);
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