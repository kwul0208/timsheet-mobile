import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Config().line))
          ),
          child: ListTile(
            title: Text("Decription of your work"),
            subtitle: Text("Full Day"),
            trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
          ),
        );
      },
    );
  }
}