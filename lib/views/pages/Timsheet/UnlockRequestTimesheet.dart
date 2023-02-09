import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';

class UnlockRequestTimesheet extends StatefulWidget {
  const UnlockRequestTimesheet({super.key, this.date});
  final String? date;

  @override
  State<UnlockRequestTimesheet> createState() => _UnlockRequestTimesheetState();
}

class _UnlockRequestTimesheetState extends State<UnlockRequestTimesheet> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController reasonC = TextEditingController();

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
        elevation: .5,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.close_outlined )),
        title: Text("Unlock Request Timesheet",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        // centerTitle: true,
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(Icons.check, size: 25, color: Config().primary,),
            ),
            onTap: (){
               if(_formKey.currentState!.validate()){
                
               }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                child: Text("${widget.date}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
              ),
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: reasonC,
                decoration: InputDecoration(
                  label: Text("Reason")
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "required";
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),  
    );
  }
}
