import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AddWFH extends StatefulWidget {
  const AddWFH({super.key});

  @override
  State<AddWFH> createState() => _AddWFHState();
}

class _AddWFHState extends State<AddWFH> {
  TextEditingController dateinput = TextEditingController();

  int _stackIndex = 0;

  String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Pending";

  final _status = ["Half Day", "Full Day"]; 
  final _condition = ["Normal", "Same Day", "Overtime"]; 

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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Add WFH",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ", style: TextStyle(color: Config().subText)),
                  TextField(
                    controller:
                        dateinput, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        hintText: 'Enter Date', //label text of field
                        border: InputBorder.none),
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
                          dateinput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            // ---
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Duration: ", style: TextStyle(color: Config().subText)),
                  SizedBox(
                    height: 50.0,
                    child: RadioGroup<String>.builder(
                      direction: Axis.horizontal,
                      groupValue: _verticalGroupValue,
                      horizontalAlignment: MainAxisAlignment.spaceAround,
                      onChanged: (value) => setState(() {
                        _verticalGroupValue = value ?? '';
                      }),
                      items: _status,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ----
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    // controller: timeStart, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "Start Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {},
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: TextField(
                    // controller: timeEnd, //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.timer), //icon of text field
                        labelText: "End Time" //label text of field
                        ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {},
                  )),
                ],
              ),
            ),
            // ----
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Planner Link: ", style: TextStyle(color: Config().subText)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset("assets/Microsoft_Planner.png", width: 50,),
                        SizedBox(width: 10,),
                        TextButton(
                          onPressed: (){

                          },
                          child: Text("Click here!"),
                        )
                        
                      ],
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller:
                        dateinput, //editing controller of this TextField
                      decoration: InputDecoration(
                        icon: Icon(Icons.add_link), //icon of text field
                        hintText: 'Copy your link here', //label text of field
                        // border: InputBorder.none
                      ),
                    ),
                    TextButton(
                      onPressed: (){

                      }, 
                      child: Text("+ Add Link")
                    )
                  ],
                ),
            ),
            // ----
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Condition", style: TextStyle(color: Config().subText)),
                  SizedBox(
                    height: 50.0,
                    child: RadioGroup<String>.builder(
                      direction: Axis.horizontal,
                      groupValue: _verticalGroupValue,
                      horizontalAlignment: MainAxisAlignment.spaceAround,
                      onChanged: (value) => setState(() {
                        _verticalGroupValue = value ?? '';
                      }),
                      items: _condition,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ----
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                maxLines: 1,
                controller: dateinput, //editing controller of this TextField
                decoration: InputDecoration(
                  icon: Icon(Icons.description_outlined), //icon of text field
                  hintText: 'Reason', //label text of field
                  border: InputBorder.none
                ),
              ),
            ),
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                maxLines: 1,
                controller: dateinput, //editing controller of this TextField
                decoration: InputDecoration(
                  icon: Icon(Icons.description_outlined), //icon of text field
                  hintText: 'Description', //label text of field
                  border: InputBorder.none
                ),
              ),
            ),
            Container(
              height: 10,
              width: width,
              color: Config().line,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Config().primary,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: (){

                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
