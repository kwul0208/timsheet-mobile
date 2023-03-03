import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/WFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/WFHModel.dart';
import 'package:timsheet_mobile/Widget/CardRWD.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerRWDList.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/DetailWFH.dart';

class Reject extends StatefulWidget {
  const Reject({super.key});

  @override
  State<Reject> createState() => _RejectState();
}

class _RejectState extends State<Reject> {

    List<WFHModel>? _wfh;
  Future<dynamic>? _futureWFH;

  @override
  void initState(){
    super.initState();
    _futureWFH = getDataWFH();
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
                  child: Text("February", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
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
            height: 10,
            color: Config().line,
          ),

         FutureBuilder(
            future: _futureWFH,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _wfh!.length,
                  itemBuilder: (context, i){
                    return CardRWD(date: _wfh![i].date, duration: _wfh![i].duration, description: _wfh![i].description, condition: _wfh![i].condition, is_overtime: _wfh![i].is_overtime, status_id: _wfh![i].status_id, start_hour: _wfh![i].start_hour, finish_hour: _wfh![i].finish_hour, id: _wfh![i].id, wfh: _wfh!,);
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
          )
        ],
      ),
    );
  }

  // -- get data wfh -- 
  Future<void> getDataWFH()async{
    _wfh = await WFHApi.getData(context, 3);
    print("----------");
    print(_wfh);
  }

}