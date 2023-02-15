import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Timesheet/mode/employees/EmployeesModel.dart';

class EmployeesApi {
  static Future<List<EmployeesModel>> getEmployees(BuildContext context) async {
    String baseUrl = Config().url;
    try {
      var response = await http.get(Uri.parse('$baseUrl/mucnet_api/api/hcis/employees?status=active'), headers: {
        'Accept': 'application/json',
      });
      List data = jsonDecode(response.body);     

      

      return EmployeesModel.EmployeesModelFromSnapshot(data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      return [];
    }
  }
}