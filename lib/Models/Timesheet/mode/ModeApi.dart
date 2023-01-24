import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/ModeModel.dart';

class ModeApi {
  static Future<List<ModeModel>> getDataMode(BuildContext context) async {
    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/mucnet_api/api/timesheet/tmode'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      Map data = jsonDecode(x);

      // print([data]);

      List _temp = [data];
      return ModeModel.ModeModelFromSnapshot(_temp);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}"),
      ));
      return [];
    }
  }
}