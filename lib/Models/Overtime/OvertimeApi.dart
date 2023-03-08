import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/OvertimeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';

class OvertimeAPi {
  static Future<List<OvertimeModel>> getDataApi(BuildContext context, String date, String employees_id) async {   
    List<Map> _errorValue = [{
      "departement": "",
      "timesheet": [],
    }];

    List<Map> _sampleData = [
        {
            "departement": "IT",
            "data": [
                {
                    "overtimeplan_id": 44601,
                    "overtimeplan_by_id": "0",
                    "employees_name": "Danti Iswandhari",
                    "employees_photo": "http://103.115.28.155:2281/mucnet/document/profile/medium/19JJ7PRW.png",
                    "description": "lembur",
                    "status": "pending",
                    "timestart": "20:00:00",
                    "timefinish": "23:00:00",
                    "inputted_at": "2023-02-08 06:47:30",
                    "inputted_by": "Danti Iswandhari",
                    "updated_at": null
                }
            ]
        },
    ];

    return OvertimeModel.OvertimeModelFromSnapshot(_errorValue);

    try {
      String baseUrl = Config().url;
      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse('$baseUrl/mucnet_api/api/overtimeplan/read'));
      request.body = json.encode({
        'category': 'all',
        'date': '2023-02-03',
        'status': 'all',
        'group_by': 'departement'
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);

        if (data['status'] == 200) {
          List _temp = [data];
          return OvertimeModel.OvertimeModelFromSnapshot(_temp);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response.reasonPhrase}"),
          ));
          Provider.of<TimesheetState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
          return OvertimeModel.OvertimeModelFromSnapshot(_errorValue);
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        print("------- no, ${response.reasonPhrase}");
        Provider.of<TimesheetState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
        return OvertimeModel.OvertimeModelFromSnapshot(_errorValue);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      print("------- ot");
      Provider.of<TimesheetState>(context, listen: false).changeError(true, "${e}");
      return OvertimeModel.OvertimeModelFromSnapshot(_errorValue);
    }
    
  }
}