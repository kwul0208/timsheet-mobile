import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';

class DetailWFH extends StatefulWidget {
  const DetailWFH({super.key});

  @override
  State<DetailWFH> createState() => _DetailWFHState();
}

class _DetailWFHState extends State<DetailWFH> {
  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("RWD Detail",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/x.png", scale: 2,)),
        actions:  [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                Image.asset("assets/delete.png", scale: 2,),
                SizedBox(width: 4,),
                Image.asset("assets/edit_active.png", scale: 2,),
                SizedBox(width: 4,),
                Image.asset("assets/check_rounded.png", scale: 1.7,),
                SizedBox(width: 8,),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("17 February 2023", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Config().orangePallet),),
              SizedBox(height: 10,),
              Badge(title: "Overtime", color: Config().blue2),
              SizedBox(height: 3,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Config().blue2
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8, right: 40, bottom: 8),
                  child: Text("Approved\nby Rizky Mutiara Aini\nat 20 February 2023", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),),
                ),
              ),
              SizedBox(height: 16,),
              Text("Duration              Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
              Text("Half Day              -", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
              SizedBox(height: 16,),
              Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
              Text("Lembur", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
              SizedBox(height: 16,),
              Text("links", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
              SizedBox(height: 6,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/mdi_link-variant.png", scale: 2,),
                  SizedBox(width: 10,),
                  Flexible(child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}