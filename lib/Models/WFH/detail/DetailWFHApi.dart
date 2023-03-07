import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHModel.dart';

class DetailWFHApi {
  static Future<List<DetailWFHModel>> getData(BuildContext context, int id) async {
    try {
      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');

      String baseUrl = Config().url;
      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              // 'http://103.115.28.155:1444/form_request/api/rwd/employees/500/detail/$id'));
              'http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/detail/$id'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        
        return DetailWFHModel.DetailWFHModelFromSnapshot([data]);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        return DetailWFHModel.DetailWFHModelFromSnapshot([]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${e}"),
        ));
      return DetailWFHModel.DetailWFHModelFromSnapshot([]);
    }

    
  }
}