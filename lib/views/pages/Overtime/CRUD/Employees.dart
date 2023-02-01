import 'package:flutter/material.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee"),
      ),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index){
          return Ink(
            child: ListTile(
              title: Text("Name Employee"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}