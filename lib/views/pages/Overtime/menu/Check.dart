import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Helper/Helper.dart';
import 'package:timsheet_mobile/Models/Overtime/OTCheck/OTCheckApi.dart';
import 'package:timsheet_mobile/Models/Overtime/OTCheck/OTCheckModel.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerRWDList.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/DetailOT.dart';
import 'package:intl/intl.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {

  List<String> _month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  TextEditingController monthController = TextEditingController(); 

  // -- data -- 
  List<OTCheckModel>? _ot;
  Future<dynamic>? _futureOt;

  @override
  void initState(){
    super.initState();

    DateTime dt = DateTime.parse("${DateTime.now()}");
    String formattedDate = DateFormat("M").format(dt);
      String formattedYear = DateFormat("yyyy").format(dt);
    _futureOt = getDataOt(formattedDate, formattedYear);
    Future.delayed(Duration.zero).then((value) {
        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(int.parse(formattedDate));
      });
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
          Container(
            height: 40,
            child: Consumer<OvertimeState>(
              builder: (context, data, _) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(1);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);

                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("1", formattedYear);

                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("January", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 1 ? Config().orangePallet : null ),),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(2);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("2", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("February", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 2 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(3);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("3", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("March", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700 , color: data.indexMonth == 3 ? Config().orangePallet : null)),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(4);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("4", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("April", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 4 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(5);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("5", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("May", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 5 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(6);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("6", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("June", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 6 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(7);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("7", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("July", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 7 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(8);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("8", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("August", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 8 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(9);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("9", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("September", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 9 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(10);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("10", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("October", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 10 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(11);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("11", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("November", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 11 ? Config().orangePallet : null )),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        Provider.of<OvertimeState>(context, listen: false).changeIndexMonth(12);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(true);
                        DateTime dt = DateTime.parse("${DateTime.now()}");
                        String formattedYear = DateFormat("yyyy").format(dt);
                        await getDataOt("12", formattedYear);
                        Provider.of<OvertimeState>(context, listen: false).changeIsLoad(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("December", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: data.indexMonth == 12 ? Config().orangePallet : null )),
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
          SizedBox(height: 4,),
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

          Consumer<OvertimeState>(
            builder: (context, data, _) {
              if (data.isLoad == false) {
                if (data.error == false) {
                  return FutureBuilder(
                    future: _futureOt,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _ot!.length,
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
                                    Builder(
                                      builder: (context) {
                                        DateTime dt = DateTime.parse("${_ot![i].date}");
                                        String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                        return Text("$formattedDate", style: TextStyle(color: Config().orangePallet, fontSize: 13, fontWeight: FontWeight.w600),);
                                      }
                                    ),
                                    SizedBox(height: 16,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                            Text("data"),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Approved", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                            Text("data"),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Periode Cut Off", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568)),),
                                            Container(
                                              width: 130,
                                              child: Text("${_ot![i].periode_cut_off}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    _ot![i].status == "approve" ?
                                      Builder(
                                        builder: (context) {
                                          DateTime dt = DateTime.parse("${_ot![i].status_date}");
                                          String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 16,),
                                              Text("Approved By", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568))),
                                              Text("${_ot![i].status_by} On ${formattedDate}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                                            ],
                                          );
                                        }
                                      ) : SizedBox(),
                                    
                                    SizedBox(height: 16,),
                                    Text("Reason of Adjustment", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(19, 19, 19, 0.568))),
                                    Text("${_ot![i].adjustment_reason ?? "-"}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                                    SizedBox(height: 6,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        Builder(
                                          builder: (context) {
                                            if (_ot![i].status == "pending") {
                                              return Badge(title: "Pending", color: Config().orangePallet,);
                                            }else if(_ot![i].status == "approve"){
                                              return Badge(title: "Approved", color: Config().bgLock2,);
                                            }else{
                                              return Badge(title: "${_ot![i].status}", color: Config().redPallet,);
                                            }
                                          }
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }else{
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ShimmerRWDList(width: width);
                          },
                        );
                      }
                    }
                  );
                }else{
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Image.asset("assets/500.png"),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("${data.message}. Please check your connection or contact IT Programmer", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                      )
                    ],
                  );
                }
              }else{
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ShimmerRWDList(width: width);
                  },
                );
              }
            }
          )
        ],
      ),
    );
  }

  Future<void> getDataOt(month, year)async{
    _ot = await OTCheckApi.getDataApi(context, month, year);
    print("--------");
    print(_ot);
  }

}
