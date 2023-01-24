import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';

class EmployeesApi {
  static Future<List<EmployeesModel>> getEmployees(BuildContext context) async {
    String baseUrl = Config().url;
    try {
      var response = await http.get(Uri.parse('http://103.115.28.155:1444/back_digital_signature/get-employees'), headers: {
        'Accept': 'application/json',
      });
      Map data = jsonDecode(response.body);     
      List _temp = [];

      if (data['meta']['code'] == 200) {
          for (var i in data['data']) {
          _temp.add(i);
        }
      } else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${data['meta']['message']}"),
        ));
      }
      

      return EmployeesModel.EmployeesModelFromSnapshot(_temp);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      return [];
    }
  }
}