import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';

class CardRWD extends StatelessWidget {
  const CardRWD({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Config().line, width: 3))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("17 February 2023", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Duration         Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
                        Text("Half Day        -", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))
                      ],
                    ),

                  ],
                ),
                Column(
                  children: [
                    Badge(title: "Ovetime", color: Config().blue2,),
                    Badge(title: "Ovetime", color: Config().blue2,),
                  ],
                )
              ],
            ),
            // SizedBox(height: 16,),
            Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, 64)),),
            Text("Lembur", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Row(
                  children: [
                    Image.asset("assets/delete.png", scale: 2.3,),
                    SizedBox(width: 4,),
                    Image.asset("assets/edit_active.png", scale: 2.3,),
                    SizedBox(width: 4,),
                    Image.asset("assets/check_rounded.png", scale: 2,),
                    SizedBox(width: 8,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, SlideRightRoute(page: DetailWFH()));
                      },
                      child: Image.asset("assets/arrow_right.png", scale: 1.9,)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}