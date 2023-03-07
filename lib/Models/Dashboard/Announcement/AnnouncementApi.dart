import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Dashboard/Announcement/AnnouncementModel.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetModel.dart';
import 'package:timsheet_mobile/Models/Timesheet/TimesheetModel.dart';

class AnnouncementApi {
  static Future<List<AnnouncementModel>> getDataApi(BuildContext context) async {
    try {
      var request = http.Request('GET', Uri.parse('https://103.115.28.155:1985/mucnet_api/api/hcis/announcement/timesheet'));


      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var x = await response.stream.bytesToString();
        Map data = jsonDecode(x);

        if (data['status'] == '200') {
        
          return AnnouncementModel.AnnouncementModelFromSnapshot(data['data']);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${data['message']} ccc"),
          ));
            return AnnouncementModel.AnnouncementModelFromSnapshot([]);
        }
        // return [];

      } else {
        print(await response.stream.bytesToString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${response.reasonPhrase}"),
        ));
        return AnnouncementModel.AnnouncementModelFromSnapshot([]);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${e}"),
        ));

      return AnnouncementModel.AnnouncementModelFromSnapshot([]);
    }
  }
}