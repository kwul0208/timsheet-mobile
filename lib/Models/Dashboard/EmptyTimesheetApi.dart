import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';

class EmptyTimesheetApi {
  static Future<List<EmptyTimesheetModel>> getDataApi(BuildContext context, int employees_id) async {
    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseUrl/mucnet_api/api/timesheet/empty-timesheet'));
    // request.body = json.encode({"employees_id": "234"});
    request.body = json.encode({"employees_id": "$employees_id"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      List data = jsonDecode(x);
      List _temp = data;

      return EmptyTimesheetModel.EmptyTimesheetModelFromSnapshot(_temp);

      return [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}. Cant get data empty timesheet"),
      ));
      return [];
    }
  }
}