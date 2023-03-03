import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';

class WFHApi {
  static Future<List<WFHModel>> getData(BuildContext context, int status ) async {
    // await Future.delayed(Duration(seconds: 2));
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
              // 'http://103.115.28.155:1444/form_request/api/rwd/employees/575/get/status/$status'));
              'http://103.115.28.155:1444/form_request/api/rwd/employees/$employees_id/get/status/$status?month=03&year=2023&orderBy=DESC'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);
        
        if (data['code'] == 200) {
          return WFHModel.WFHModelFromSnapshot(data['data']);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${data['message']}"),
          ));
            Provider.of<WFHState>(context, listen: false).changeError(true, '${data['message']}');
            return WFHModel.WFHModelFromSnapshot([]);
        }
        // return [];

      } else {
        print(await response.stream.bytesToString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        Provider.of<WFHState>(context, listen: false).changeError(true, '${response.reasonPhrase}');
        return WFHModel.WFHModelFromSnapshot([]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${e}"),
        ));
      Provider.of<WFHState>(context, listen: false).changeError(true, '${e}');

      return WFHModel.WFHModelFromSnapshot([]);
    }

    
  }
}