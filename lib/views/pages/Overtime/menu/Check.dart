import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
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
          Container(
            height: 40,
            child: Consumer<WFHState>(
              builder: (context, data, _) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(1);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(1, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("January", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 1 ? Config().orangePallet : null ),),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(2);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(2, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("February", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 2 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(3);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(3, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("March", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 , color: data.indexMonth == 3 ? Config().orangePallet : null)),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(4);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(4, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("April", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 4 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(5);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(5, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("May", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 5 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(6);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(6, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("June", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 6 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(7);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(7, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("July", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 7 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(8);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(8, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("August", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 8 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(9);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(9, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("September", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 9 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(10);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(10, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("October", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 10 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(11);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(11, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("November", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 11 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        // Provider.of<WFHState>(context, listen: false).changeIndexMonth(12);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                        // await getDataWFH(12, year);
                        // Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("December", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 12 ? Config().orangePallet : null )),
                      ),
                    ),
                  ],
                );
              }
              ),
            ),
        
          // Consumer<WFHState>(
          //   builder: (context, data, _) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         GestureDetector(
          //           onTap: (){
          //             // year = 2021;
          //             // Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
          //             // Provider.of<WFHState>(context, listen: false).changeIndexYear(1);
          //           },
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: data.indexYear == 1 ? Config().orangePallet : null,
          //               borderRadius: BorderRadius.circular(10)
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //               child: Text("2021", style: TextStyle(color: data.indexYear == 1 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: (){
          //             // year = 2022;
          //             // Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
          //             // Provider.of<WFHState>(context, listen: false).changeIndexYear(2);
          //           },
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: data.indexYear == 2 ? Config().orangePallet : null,
          //               borderRadius: BorderRadius.circular(10)
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //               child: Text("2022", style: TextStyle(color: data.indexYear == 2 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: (){
          //             // year = 2023;
          //             // Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
          //             // Provider.of<WFHState>(context, listen: false).changeIndexYear(3);
          //           },
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: data.indexYear == 3 ? Config().orangePallet : null,
          //               borderRadius: BorderRadius.circular(10)
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //               child: Text("2023", style: TextStyle(color: data.indexYear == 3 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
          //             ),
          //           ),
          //         )
          //       ],
          //     );
          //   }
          // ),
          SizedBox(height: 16,),
          // Container(
          //   width: width,
          //   height: 20,
          //   decoration: BoxDecoration(
          //     // color: Colors.white,
          //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
          //   ),
          // ),
          Container(
            width: width,
            height: 10,
            color: Config().line,
          ),
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
                      Text("17 February 2023", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),),
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
                                        width: width/3,
                                        child: Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),)
                                      ),
                                      SizedBox(width: 30,),
                                      Text("Approved", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width/3,
                                        child: Text("05:00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),   
                                      SizedBox(width: 30,),
                                      Text("04:00", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                                         
                                    ],
                                  )
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16,),
                      Text("Reason of Adjustment", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568))),
                      Text("-", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                      SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Badge(title: "Pending", color: Config().orangePallet,),
                        ],
                      )
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
