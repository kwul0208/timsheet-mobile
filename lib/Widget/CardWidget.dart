import "package:flutter/material.dart";
import 'package:timsheet_mobile/Config/Config.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.title, required this.total, required this.img
  }) : super(key: key);

  final String title;
  final int total;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: Color.fromARGB(255, 221, 221, 221),
                offset: Offset(0, 5))
          ] // Make rounded corner of border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(icon, color: Config().primary, size: 30,),
            Image.asset('assets/$img', scale: 2,),
            Text("$total", style: TextStyle(color: Config().primary, fontSize: 44, fontWeight: FontWeight.w500),),
            Align(child: Text(title, style: TextStyle(color: Config().primary, fontSize: 14, fontWeight: FontWeight.w600), textAlign: TextAlign.center,))
          ],
        ),
      ),
    );
  }
}