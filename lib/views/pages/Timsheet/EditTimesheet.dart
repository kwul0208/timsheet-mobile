import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:intl/intl.dart';

class EditTimesheet extends StatefulWidget {
  const EditTimesheet({super.key});

  @override
  State<EditTimesheet> createState() => _EditTimesheetState();
}

class _EditTimesheetState extends State<EditTimesheet> {

  List options = [
    {'title': 'Prospecting', 'isActive': false},
    {'title': 'Daily Routine', 'isActive': false},
    {'title': 'Self Development', 'isActive': false},
    {'title': 'Client', 'isActive': false},
    {'title': 'Tax Office', 'isActive': false},
    {'title': 'Ishoma', 'isActive': false},
    {'title': 'Suport Service', 'isActive': false},
    {'title': 'Training', 'isActive': false},
    {'title': 'Project', 'isActive': false},
  ];

  // form
  TextEditingController dateinput = TextEditingController(); 
  TextEditingController timeStart = TextEditingController(); 
  TextEditingController timeEnd = TextEditingController(); 



  @override
  void initState(){
    super.initState();
  }


  //MODE
  changeState(item) {
    // print(item);
    setState(() {
      item['isActive'] = !item['isActive'];
    });
  
    for (var op in options) {
    if (op['title'] != item['title']) {
        setState(() {
          op['isActive'] = false;
        });
      }    }
  }

  customBoxDecoration(isActive) {
    return BoxDecoration(
      color: isActive ? Config().primary : Colors.white,
      border: Border(
        left: BorderSide(color: Colors.black12, width: 1.0),
        bottom: BorderSide(color: Colors.black12, width: 1.0),
        top: BorderSide(color: Colors.black12, width: 1.0),
        right: BorderSide(color: Colors.black12, width: 1.0)),
        borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Edit Timesheet",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(
                child: Text(
              "Update",
              style: TextStyle(color: Colors.green, fontSize: 16),
            )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: dateinput, //editing controller of this TextField
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2022), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2024));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                       dateinput.text = formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: timeStart, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        print(pickedTime.format(context)); //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          timeStart.text = formattedTime; //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: TextField(
                    controller: timeEnd, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "Enter Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );

                      if (pickedTime != null) {
                        print(pickedTime.format(context)); //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.

                        setState(() {
                          timeEnd.text = formattedTime; //set the value of text field.
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  )),
                ],
              ),
              SizedBox(height: 30,),
              TextFormField(
                decoration: InputDecoration(
                  label: Text("Description"),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Config().line,)
                  )
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20,),
              Text("Mode", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
              SizedBox(height: 10,),
              Wrap(
                spacing: 10.0,
                runSpacing: 20.0,
                children: options
                .map((option) =>  Container(
                // margin: EdgeInsets.all(5),
                  decoration: customBoxDecoration(option['isActive']),
                  child: InkWell(
                    onTap: () {
                      changeState(option);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('${option['title']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: option['isActive']
                        ? Colors.white
                        : Colors.black87)
                      )
                    )
                  )
                )
                ).toList()
              )

            ],
          ),
        ),
      ),
    );
  }
}
