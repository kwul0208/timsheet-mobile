import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';

class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Config().line))
          ),
          child: Ink(
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWFH()));
              },
              title: Text("Decription of your work"),
              subtitle: Text("Full Day"),
              trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
            ),
          ),
        );
      },
    );
  }
}