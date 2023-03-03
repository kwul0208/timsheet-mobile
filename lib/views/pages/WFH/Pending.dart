import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/Widget/CardRWD.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerRWDList.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/AddWFH.dart';


class Pending extends StatefulWidget {
  const Pending({super.key});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {

  List<WFHModel>? _wfh;
  Future<dynamic>? _futureWFH;

  @override
  void initState(){
    super.initState();
    _futureWFH = getDataWFH();
  }

  Future<void> _displaySecondView(Widget view) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => view));

    if (!mounted) return;
    print('result');
    print(result);
    if (result != null) {
      Timer(Duration(milliseconds: 100), () async {
        await getDataWFH();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("January", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("February", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("March", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700 , color: Config().orangePallet)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("April", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("May", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("June", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("July", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("August", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("September", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("October", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("November", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("December", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
        
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // color: Config().orangePallet,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text("2021", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // color: Config().orangePallet,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text("2022", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Config().orangePallet,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text("2023", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                Container(
                  width: width,
                  height: 20,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
                  ),
                ),
                Container(
                  width: width,
                  height: 10,
                  color: Config().line,
                ),
              ],
            ),
            
            Consumer<WFHState>(
              builder: (context, data, _) {
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
              }
            )
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: Config().primary,
        child: Icon(Icons.add),
        onPressed: (){
          _displaySecondView(AddWFH());
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddWFH()));
        },
      )
    );
  }

  
  // -- get data wfh -- 
  Future<void> getDataWFH()async{
    _wfh = await WFHApi.getData(context, 1);
    print("----------");
    print(_wfh);
  }

}

