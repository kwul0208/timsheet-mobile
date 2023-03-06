import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Widget/CardRWD.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerRWDList.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';
import 'package:intl/intl.dart';

class Approved extends StatefulWidget {
  const Approved({super.key});

  @override
  State<Approved> createState() => _ApprovedState();
}

class _ApprovedState extends State<Approved> {
  List<WFHModel>? _wfh;
  Future<dynamic>? _futureWFH;

  int year = 2023;
  int month = 3;

  @override
  void initState(){
    super.initState();
    // -- initial month --
    DateTime dt = DateTime.parse("${DateTime.now()}");
    String formattedDate = DateFormat("M").format(dt);
    int indexMonth = int.parse(formattedDate);
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WFHState>(context, listen: false).changeIndexMonth(indexMonth);
      Provider.of<WFHState>(context, listen: false).changeIndexYear(3);
    });
    year = int.parse(DateFormat("yyyy").format(dt));
    _futureWFH = getDataWFH(indexMonth, year);
    month = indexMonth;

  }

  Future<void> _displaySecondView(Widget view) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => view));

    if (!mounted) return;
    print('result');
    print(result);
    if (result != null) {
      Timer(Duration(milliseconds: 100), () async {
        await getDataWFH(month, year);
        print('reloaddd');
          Provider.of<WFHState>(context, listen: false).changeRefresh();
      });
    }
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
          Column(
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
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(1);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(1, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("January", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 1 ? Config().orangePallet : null ),),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(2);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(2, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("February", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 2 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(3);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(3, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("March", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 , color: data.indexMonth == 3 ? Config().orangePallet : null)),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(4);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(4, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("April", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 4 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(5);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(5, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("May", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 5 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(6);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(6, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("June", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 6 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(7);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(7, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("July", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 7 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(8);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(8, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("August", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 8 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(9);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(9, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("September", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 9 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(10);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(10, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("October", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 10 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(11);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(11, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("November", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: data.indexMonth == 11 ? Config().orangePallet : null )),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Provider.of<WFHState>(context, listen: false).changeIndexMonth(12);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(true);
                              await getDataWFH(12, year);
                              Provider.of<WFHState>(context, listen: false).changeIsLoad(false);
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
        
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            year = 2021;
                            Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
                            Provider.of<WFHState>(context, listen: false).changeIndexYear(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: data.indexYear == 1 ? Config().orangePallet : null,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Text("2021", style: TextStyle(color: data.indexYear == 1 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            year = 2022;
                            Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
                            Provider.of<WFHState>(context, listen: false).changeIndexYear(2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: data.indexYear == 2 ? Config().orangePallet : null,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Text("2022", style: TextStyle(color: data.indexYear == 2 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            year = 2023;
                            Provider.of<WFHState>(context, listen: false).changeIndexMonth(0);
                            Provider.of<WFHState>(context, listen: false).changeIndexYear(3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: data.indexYear == 3 ? Config().orangePallet : null,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Text("2023", style: TextStyle(color: data.indexYear == 3 ? Colors.white : Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                ),

              SizedBox(height: 16,),
              Container(
                width: width,
                height: 10,
                color: Config().line,
              ),
          
            ],
          ),
          
          Consumer<WFHState>(
              builder: (context, data, _) {
                if (data.isLoad == false) {
                  if (data.error == false) {
                    return FutureBuilder(
                      future: _futureWFH,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _wfh!.length,
                            itemBuilder: (context, i){
                              return CardRWD(date: _wfh![i].date, duration: _wfh![i].duration, description: _wfh![i].description, condition: _wfh![i].condition, is_overtime: _wfh![i].is_overtime, status_id: _wfh![i].status_id, start_hour: _wfh![i].start_hour, finish_hour: _wfh![i].finish_hour, id: _wfh![i].id, wfh: _wfh!, secondView: _displaySecondView);
                            }
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

  // -- get data wfh -- 
  Future<void> getDataWFH(month, year)async{
    _wfh = await WFHApi.getData(context, 2, month, year);
    print("----------");
    print(_wfh);
  }
}
