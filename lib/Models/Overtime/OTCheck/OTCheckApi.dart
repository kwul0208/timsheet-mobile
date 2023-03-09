import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/OTCheck/OTCheckModel.dart';
import 'package:timsheet_mobile/Models/Overtime/OTPlan/OTPlanModel.dart';
import 'package:timsheet_mobile/Models/Overtime/OvertimeModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';

class OTCheckApi {
  static Future<List<OTCheckModel>> getDataApi(BuildContext context, String month, String year) async {   
    try {

      final storage = new FlutterSecureStorage();
      var employees_id = await storage.read(key: 'employees_id');

      String baseUrl = Config().url;

      var request = http.Request('GET', Uri.parse('$baseUrl/mucnet_api/api/overtimecheck?employees_id=$employees_id&month=$month&year=$year'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);

        if(data['status'] == "200"){
          return OTCheckModel.OTCheckModelFromSnapshot(data['data']);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response.reasonPhrase}"),
          ));
          print("------- no, ${response.reasonPhrase}");
          Provider.of<OvertimeState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
          return OTCheckModel.OTCheckModelFromSnapshot([]);
        }


      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        print("------- no, ${response.reasonPhrase}");
        Provider.of<OvertimeState>(context, listen: false).changeError(true, "${response.reasonPhrase}");
        return OTCheckModel.OTCheckModelFromSnapshot([]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${e}"),
      ));
      print("------- ot");
      Provider.of<OvertimeState>(context, listen: false).changeError(true, "${e}");
      return OTCheckModel.OTCheckModelFromSnapshot([]);
    }
    
  }
}