import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';

class TimesheetApi {
  static Future<List<TimesheetModel>> getDataApi(BuildContext context, String date, String employees_id) async {   
    List<Map> _errorValue = [{
        "timesheet": [],
        "status": "open",
        "locked_date": "2024-02-06",
        "unlocked_request_date": null,
        "unlocked_date": null,
        "relocked_date": null,
        "work_from": null,
        "wfo_start": null,
        "wfo_finish": null,
        "wfh_start": null,
        "wfh_finish": null,
        "summary": {
            "chargeable": 0,
            "business_travel": 0,
            "development": 0,
            "ishoma": 0,
            "office_administration": 0,
            "prospecting": 0,
            "support": 0,
            "training": 0,
            "working_time": 0,
            "over_time": 0
        }
    }];
    try {
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
          print("---------ok");

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
        print("------- no, ${response.reasonPhrase}");
        Provider.of<TimesheetState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
        return TimesheetModel.TimesheetModelFromSnapshot(_errorValue);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${e}"),
        ));
        print("------- ot");
         Provider.of<TimesheetState>(context, listen: false).changeError(true, "${e}");
        return TimesheetModel.TimesheetModelFromSnapshot(_errorValue);
    }
    
  }
}