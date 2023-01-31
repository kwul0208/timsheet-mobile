import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';

class DetailWFH extends StatefulWidget {
  const DetailWFH({super.key});

  @override
  State<DetailWFH> createState() => _DetailWFHState();
}

class _DetailWFHState extends State<DetailWFH> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Datail WFH",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        // actions:  [
        //   GestureDetector(
        //     onTap: (){
        //       // _showConfirm();
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 10),
        //       child: TextButton(
        //         child: Text("Edit"),
        //       )
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // --- Status ---
              Row(
                children: [
                  Text("Status", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 70,),
                  Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("Pending", style: TextStyle(color: Colors.white, fontSize: 11),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Name ---
              Row(
                children: [
                  Text("Name", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 70,),
                  Flexible(child: Text("Ahmad Wahyu Awaludin", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Condition ---
              Row(
                children: [
                  Text("Condition", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 45,),
                  Flexible(child: Text("Same Day", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Date ---
              Row(
                children: [
                  Text("Date", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 83,),
                  Flexible(child: Text("30 January 2023", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Last Update ---
              Row(
                children: [
                  Text("Last Updated", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 18,),
                  Flexible(child: Text("30 January 2023", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Duration ---
              Row(
                children: [
                  Text("Duration", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 57,),
                  Flexible(child: Text("Full Day", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // --- Reason ---
              Row(
                children: [
                  Text("Reason", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 63,),
                  Flexible(child: Text("Wfh", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 20),

              // --- Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: (){
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                     Text(
                      'Done',
                      style: TextStyle(fontSize: 24),
                    ),
                    Icon(Icons.check, size: 30,)
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Config().primary,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditWFH()));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                     Text(
                      'Edit',
                      style: TextStyle(fontSize: 24),
                    ),
                    Icon(Icons.navigate_next_outlined, size: 30,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}