import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';

class Cuti extends StatefulWidget {
  const Cuti({super.key});

  @override
  State<Cuti> createState() => _CutiState();
}

class _CutiState extends State<Cuti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Config().primary,
        title: Text("Leave", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),),
        centerTitle: true,  
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/maintenance.png"),
            Text("This page is under construction", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),)
          ],
        ),
      ),
    );
  }
}