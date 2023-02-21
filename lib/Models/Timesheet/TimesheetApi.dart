import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';

class TimesheetApi {
  static Future<List<TimesheetModel>> getDataApi(BuildContext context, String date, String employees_id) async {
    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseUrl/mucnet_api/api/timesheet/read'));
    // request.body = json.encode({"date": "$date", "employees_id": "116"});
    request.body = json.encode({"date": "$date", "employees_id": "$employees_id"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      Map data = jsonDecode(x);

      print([data]);

      List _temp = [data];

      // if (data['status'] == 200) {
        // for (var i in [data]) {
        //   print('i');
        //   print(i);
        // }

        return TimesheetModel.TimesheetModelFromSnapshot(_temp);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("Failed! something wrong"),
      //   ));
      //   return [];
      // }
      return [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}"),
      ));
      return [];
    }
  }
}