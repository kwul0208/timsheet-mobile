import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileModel.dart';

class ProfileApi {
  static Future<List<ProfileModel>> getDataAssignment(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');

    String baseUrl = Config().url;
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            // '$baseUrl/mucnet_api/api/hcis/employees?status=active&employees_id=533'));
            '$baseUrl/mucnet_api/api/hcis/employees?status=active&employees_id=$employees_id'));

 

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      print(x);
      List data = jsonDecode(x);
      // return [];
      return ProfileModel.ProfileModelFromSnapshot(data);

    } else {
      print('errorrrrrr');
      print(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${response.reasonPhrase}, failed get data profile"),
      ));
      return [];
    }
  }
}