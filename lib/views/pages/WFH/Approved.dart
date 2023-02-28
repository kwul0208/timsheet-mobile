import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Widget/CardRWD.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';

class Approved extends StatefulWidget {
  const Approved({super.key});

  @override
  State<Approved> createState() => _ApprovedState();
}

class _ApprovedState extends State<Approved> {
  @override
  Widget build(BuildContext context) {
            var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("January", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("February", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Config().orangePallet)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("March", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("April", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("May", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("June", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("July", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("August", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("September", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("October", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("November", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("December", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: Config().orangePallet,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("2021", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Config().orangePallet,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("2022", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Config().orangePallet,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("2023", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),),
                ),
              )
            ],
          ),

          SizedBox(height: 16,),
          Container(
            width: width,
            height: 10,
            color: Config().line,
          ),
          
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, i){
              return CardRWD();
            }
          )
        ],
      ),
    );
  }
}