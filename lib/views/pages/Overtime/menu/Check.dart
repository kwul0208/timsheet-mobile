import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/DetailOT.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {

  List<String> _month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  TextEditingController monthController = TextEditingController(); 


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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Flexible(
                  child: Consumer<OvertimeState>(
                    builder: (context, data, _) {
                      return TextField(
                        readOnly: true,
                        controller: monthController..text = data.nameMonth,
                        decoration: InputDecoration(
                          hintText: "Select Month",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: .0, horizontal: 10.0),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Config().primary,
                              width: 1.0,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet<void>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    "Select Month",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _month.length,
                                      itemBuilder: ((context, i) {
                                        return Ink(
                                          child: ListTile(
                                            title: Text('${_month[i]}'),
                                            onTap: () {
                                              Provider.of<OvertimeState>(context, listen: false).changeNameMonth(_month[i]);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: Icon(
                    Icons.calendar_month,
                    color: Config().redAccent,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: width,
            height: 10,
            color: Config().line,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1, color: Config().line))
                ),
                child: Ink(
                  child: ListTile(
                    title: Text("Decription of your Overtime"),
                    subtitle: Text("Time: 20:00 - 22:00"),
                    trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailOT()));
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
