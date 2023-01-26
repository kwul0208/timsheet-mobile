import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';

class TimeExistapi {
  static Future<List> getTime(BuildContext context, String date, String employees_id) async {
    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            '$baseUrl/mucnet_api/api/timesheet/check-time-exist'));
    request.body = json.encode({"date": "$date", "employees_id": "$employees_id"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      List data = jsonDecode(x);
      return data;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}"),
      ));
      return [];
    }
  }
}