import "package:flutter/material.dart";

class Badge extends StatelessWidget {
  const Badge({
    Key? key, required this.title, required this.color
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text("$title", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),),
        ),
      ),
    );
  }
}