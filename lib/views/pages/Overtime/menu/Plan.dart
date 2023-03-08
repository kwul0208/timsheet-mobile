import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/InputForModel.dart';
import 'package:timsheet_mobile/Models/Overtime/Dropdown/StatusModel.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/DetailOT.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/EditOT.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  // data Dropdown
  InputFor? selectedUser;
  List<InputFor> users = <InputFor>[
    const InputFor("me", 'Me'),
    const InputFor("others", 'Others')
  ];
  StatusModel? selectedStatus;
  List<StatusModel> statuss = <StatusModel>[
    const StatusModel("pending", 'Pending'),
    const StatusModel("approved", 'Approved'),
    const StatusModel("rejected", 'Rejected')
  ];

  @override
  void initState() {
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
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       DecoratedBox(
          //         decoration: BoxDecoration(
          //           color: Colors.white, //background color of dropdown button
          //           // border: Border.all(color: Colors.black38, width:3), //border of dropdown button
          //           borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
          //           boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
          //                   BoxShadow(
          //                       color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
          //                       blurRadius: 1) //blur radius of shadow
          //                 ]
          //         ),
          //         child: DropdownButton<InputFor>(
          //         hint: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Text(" Input For "),
          //         ),
          //         value: selectedUser,
          //         onChanged: (InputFor? newValue) {
          //           setState(() {
          //             selectedUser = newValue;
          //           });
          //         },
          //         items: users.map((InputFor user) {
          //             return  DropdownMenuItem<InputFor>(
          //               value: user,
          //               child:  Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Text(
          //                   user.name,
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //               ),

          //             );
          //           }).toList(),
          //         underline: Container(),
          //         ),
          //       ),
          //       DecoratedBox(
          //         decoration: BoxDecoration(
          //           color:Colors.white, //background color of dropdown button
          //           // border: Border.all(color: Colors.black38, width:3), //border of dropdown button
          //           borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
          //           boxShadow: <BoxShadow>[ //apply shadow on Dropdown button
          //                   BoxShadow(
          //                       color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
          //                       blurRadius: 1) //blur radius of shadow
          //                 ]
          //         ),
          //         child: DropdownButton<StatusModel>(
          //         hint: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Text(" Status "),
          //         ),
          //         value: selectedStatus,
          //         onChanged: (StatusModel? newValue) {
          //           setState(() {
          //             selectedStatus = newValue;
          //           });
          //         },
          //         items: statuss.map((StatusModel user) {
          //             return  DropdownMenuItem<StatusModel>(
          //               value: user,
          //               child:  Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Text(
          //                   user.name,
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //               ),
          //             );
          //           }).toList(),
          //           underline: Container(),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10),
          //   child: Divider(),
          // )
          CalendarTimeline(
            initialDate: DateTime.now(),
            firstDate: DateTime(2022, 12, 01),
            lastDate: DateTime(2024, 01, 01),
            onDateSelected: (date) {},
            leftMargin: 20,
            monthColor: Colors.black,
            dayColor: Colors.black,
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.orange,
            dotsColor: Color(0xFF333A47),
            // selectableDayPredicate: (date) => date.day != 23,
            // locale: 'en_ISO',
            showYears: false,
          ),
          Container(
            width: width,
            height: 10,
            color: Config().line,
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: 15,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       decoration: BoxDecoration(
          //         border: Border(bottom: BorderSide(width: 1, color: Config().line))
          //       ),
          //       child: Ink(
          //         child: ListTile(
          //           title: Text("Decription of your Overtime"),
          //           subtitle: Text("Time: 20:00 - 22:00"),
          //           trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
          //           onTap: (){
          //             Navigator.push(context, MaterialPageRoute(builder: (context) => DetailOT()));
          //           },
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Container(
          //     width: width,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(10),
          //         boxShadow: [
          //           BoxShadow(
          //               blurRadius: 5,
          //               color: Color.fromARGB(255, 221, 221, 221),
          //               offset: Offset(0, 5))
          //         ]),
          //     child: Padding(
          //       padding: const EdgeInsets.all(10.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text("IT Departement",
          //               style: TextStyle(
          //                   color: Config().primary, fontWeight: FontWeight.w700, fontSize: 14)),
          //           SizedBox(height: 10,),
          //           Container(
          //             width: width,
          //             height: 60,
          //             child: ListView.builder(
          //               shrinkWrap: true,
          //               scrollDirection: Axis.horizontal,
          //               itemCount: 3,
          //               itemBuilder: (context, i) {
          //                 return Padding(
          //                   padding: const EdgeInsets.only(right: 5),
          //                   child: CircleAvatar(
          //                     backgroundColor: i == 1 ? Config().primary : Colors.white,
          //                     radius: 26.0,
          //                     child: CircleAvatar(
          //                       backgroundImage: AssetImage("assets/ahmad.png"),
          //                       radius: 23.0,
          //                     ),
          //                   ),
          //                 );
          //               },
          //             ),
          //           ),
          //           Container(
          //             width: width,
          //             decoration: BoxDecoration(
          //               color: Config().grey2,
          //               borderRadius: BorderRadius.circular(8)
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text("Danti Iswandhari", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),),
          //                       Row(
          //                         children: [
          //                           Icon(Icons.access_time, size: 20,),
          //                           SizedBox(width: 4,),
          //                           Column(
          //                             crossAxisAlignment: CrossAxisAlignment.start,
          //                             children: [
          //                               Text("10:00 - 11:00", style: TextStyle(fontSize: 13),),
          //                               Text("Lembur", style: TextStyle(fontSize: 13))
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                   Row(
          //                     children: [
          //                       Image.asset('assets/delete.png', scale: 2,),
          //                       SizedBox(width: 10),
          //                       GestureDetector(
          //                         onTap: (){
          //                           Navigator.push(context, MaterialPageRoute(builder: (context) => EditOT()));
          //                         },
          //                         child: Image.asset('assets/edit_active.png', scale: 2,)
          //                       ),
          //                     ],
          //                   )
          //                 ],
          //               ),
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // )
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, i){
              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Config().line, width: 2))
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tiara Alifa Anzania Putri", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),),
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
                                  Row(
                                    children: [
                                      Container(
                                        width: width/2,
                                        child: Text("Filled by", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),)
                                      ),
                                      SizedBox(width: 30,),
                                      Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width/2,
                                        child: Text("Franco Hardyan Dewayani Putra", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),   
                                      SizedBox(width: 30,),
                                      Text("05:00 - 06:00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                                         
                                    ],
                                  )
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568))),
                      Text("TCD Asia Pacific", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
