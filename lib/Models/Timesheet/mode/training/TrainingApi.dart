import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/project/ProjectModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/training/TrainingModel.dart';

class TrainingApi {
  static Future<List<TrainingModel>> getDataProject(BuildContext context, String date) async {
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');

    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$baseUrl/mucnet_api/api/training/read?employees_id=$employees_id&date=$date'));
            // '$baseUrl/mucnet_api/api/training/read?employees_id=402&date=2023-01-24'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      List data = jsonDecode(x);
      print(data);
      // return [];
      return TrainingModel.TrainingModelFromSnapshot(data);

    } else {
      print('false');
      print(await response.stream.bytesToString());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("${response.reasonPhrase}"),
      // ));
      return [];
    }
  }
}