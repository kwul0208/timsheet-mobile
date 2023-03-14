import "package:flutter/material.dart";
import "package:intl/intl.dart";

class RequestUnlockOTPlan extends StatefulWidget {
  const RequestUnlockOTPlan({super.key, this.date});
  final String ? date;

  @override
  State<RequestUnlockOTPlan> createState() => _RequestUnlockOTPlanState();
}

class _RequestUnlockOTPlanState extends State<RequestUnlockOTPlan> {
  TextEditingController reasonC = TextEditingController();


  @override
  Widget build(BuildContext context) {
  DateTime dt = DateTime.parse("${widget.date}");
  String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
   return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/x.png", scale: 1.8,)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Unlock Request OT Plan",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: ()async{

            },
          child: Image.asset("assets/check.png", scale: 1.8,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // width: width/1.8,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("${DateFormat('EEEE').format(dt)}, ${formattedDate}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
              ),
            ),
            TextFormField(
              maxLines: 2,
              controller: reasonC,
              decoration: InputDecoration(
                label: Text("Reason")
              ),
            )
          ],
        ),
      ),
    );
  }
}