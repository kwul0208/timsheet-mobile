import 'package:flutter/material.dart';

class CardArticle extends StatelessWidget {
  const CardArticle({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: Color.fromARGB(255, 221, 221, 221),
                offset: Offset(0, 5))
          ] //
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("assets/aliza.jpg"),
              ),
              title: Text("Aliza"),
              subtitle: Text("3 dasy ago"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Dear All, Cutoff Timesheet & Overtime bulan Januari jatuh pada hari Senin, 16 Januari 2023. Periode Kerja (17 Desember 2022 - 16 Januari 2023). Total 21 hari kerja...", style: TextStyle(color: Colors.black54, fontSize: 12),),
            )
          ],
        )
      ),
    );
  }
}