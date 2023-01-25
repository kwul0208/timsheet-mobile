import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/assignment/AssignmentModel.dart';

class AssignmentApi {
  static Future<List<AssignmentModel>> getDataMode(BuildContext context) async {
    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/mucnet_api/api/assignment-consultant'));

      request.body = json.encode({
        "date": "2023-01-22",
        "employees_id": 443
      });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      List data = jsonDecode(x);

      return AssignmentModel.AssignmentModelFromSnapshot(data);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}"),
      ));
      return [];
    }
  }
}