import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/InputForModel.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/StatusModel.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  // data Dropdown
  InputFor? selectedUser;
  List<InputFor> users = <InputFor>[const InputFor("me",'Me'), const InputFor("others",'Others')];
  StatusModel? selectedStatus;
  List<StatusModel> statuss = <StatusModel>[const StatusModel("pending",'Pending'), const StatusModel("approved",'Approved'), const StatusModel("rejected",'Rejected')];

  @override 
  void initState(){
    super.initState();
  }

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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration( 
                    color: Colors.white, //background color of dropdown button
                    // border: Border.all(color: Colors.black38, width:3), //border of dropdown button
                    borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                blurRadius: 1) //blur radius of shadow
                          ]
                  ),
                  child: DropdownButton<InputFor>(
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" Input For "),
                  ),
                  value: selectedUser,
                  onChanged: (InputFor? newValue) {
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                  items: users.map((InputFor user) {
                      return  DropdownMenuItem<InputFor>(
                        value: user,
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        
                      );
                    }).toList(),
                  underline: Container(),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration( 
                    color:Colors.white, //background color of dropdown button
                    // border: Border.all(color: Colors.black38, width:3), //border of dropdown button
                    borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
                    boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                blurRadius: 1) //blur radius of shadow
                          ]
                  ),
                  child: DropdownButton<StatusModel>(
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" Status "),
                  ),
                  value: selectedStatus,
                  onChanged: (StatusModel? newValue) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                  },
                  items: statuss.map((StatusModel user) {
                      return  DropdownMenuItem<StatusModel>(
                        value: user,
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            user.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                    underline: Container(),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Divider(),
          // )
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
                child: ListTile(
                  title: Text("Decription of your Overtime"),
                  subtitle: Text("Time: 20:00 - 22:00"),
                  trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
