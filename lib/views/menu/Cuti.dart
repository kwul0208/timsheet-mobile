import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class Cuti extends StatefulWidget {
  const Cuti({super.key});

  @override
  State<Cuti> createState() => _CutiState();
}

class _CutiState extends State<Cuti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Cuti")),
    );
  }
}