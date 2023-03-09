import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/OTPlan/OTPlanModel.dart';
import 'package:timsheet_mobile/Models/Overtime/OvertimeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';

class OTPlanApi {
  static Future<List<OTPlanModel>> getDataApi(BuildContext context, String date) async {   

    try {
      String baseUrl = Config().url;
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      var request = http.Request('POST', Uri.parse('$baseUrl/mucnet_api/api/overtimeplan/read'));
      request.bodyFields = {
        'category': 'all',
        'date': '$date',
        'status': 'all'
      };
      request.headers.addAll(headers);
      
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        List data = jsonDecode(x);

        return OTPlanModel.OTPlanModelFromSnapshot(data);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        print("------- no, ${response.reasonPhrase}");
        Provider.of<OvertimeState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
        return OTPlanModel.OTPlanModelFromSnapshot([]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      print("------- ot");
      Provider.of<OvertimeState>(context, listen: false).changeError(true, "${e}");
      return OTPlanModel.OTPlanModelFromSnapshot([]);
    }
    
  }
}