import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHApi.dart';
import 'package:timsheet_mobile/Models/WFH/detail/DetailWFHModel.dart';
import 'package:timsheet_mobile/Routing/SlideRightRoute.dart';
import 'package:timsheet_mobile/Widget/Badge.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';
import 'package:intl/intl.dart';

class DetailWFH extends StatefulWidget {
  const DetailWFH({super.key, this.id, this.start_hour, this.finish_hour, this.duration, this.condition, this.status_id, this.is_overtime});
  final int ? id;
  final String ? start_hour;
  final String ? finish_hour;
  final String ? duration;
  final String ? condition;
  final int ? status_id;
  final int ? is_overtime;
  

  @override
  State<DetailWFH> createState() => _DetailWFHState();
}

class _DetailWFHState extends State<DetailWFH> {
  
  List<DetailWFHModel>? _wfh;
  Future<dynamic>? _futureWfh;

  @override
  void initState(){
    super.initState();

    _futureWfh = getDataWfh();
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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("RWD Detail",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: false,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset("assets/x.png", scale: 2,)),
        actions:  [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                widget.status_id == 1 ?
                Image.asset("assets/delete.png", scale: 2,) : SizedBox(),
                SizedBox(width: 4,),
                widget.status_id == 1 || widget.status_id == 2 || widget.status_id == 4 ?
                Image.asset("assets/edit_active.png", scale: 2,) : SizedBox(),
                SizedBox(width: 4,),
                widget.status_id == 2 ?
                Image.asset("assets/check_rounded.png", scale: 1.7,) : SizedBox(),
                SizedBox(width: 8,),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futureWfh,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {


            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        DateTime dt = DateTime.parse("${_wfh![0].date}");
                        String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                        return Text("${formattedDate}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Config().orangePallet),);
                      }
                    ),
                    SizedBox(height: 10,),
                    widget.is_overtime == 1 ? Badge(title: "Overtime", color: Config().blue2) : SizedBox(),
                    SizedBox(height: 3,),
                    Builder(
                      builder: (context) {
                        if(widget.status_id == 1){
                          return Badge(title: "Pending", color: Config().orangePallet,);
                        }else if (widget.status_id == 2) {
                          DateTime dt = DateTime.parse("${_wfh![0].approved_date}");
                          String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Config().blue2
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, top: 8, right: 40, bottom: 8),
                              child: Text("${_wfh![0].status!['status_name']}\nby ${_wfh![0].approved_by!['fullname']}\nat ${formattedDate}", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),)
                                
                            ),
                          );
                        } else if(widget.status_id == 3) {
                          DateTime dt = DateTime.parse("${_wfh![0].rejected_date}");
                          String formattedDate = DateFormat("dd MMMM yyyy").format(dt);
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Config().redPallet
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, top: 8, right: 40, bottom: 8),
                              child: Text("${_wfh![0].status!['status_name']}\nby ${_wfh![0].rejected_by!['fullname']}\nat ${formattedDate}", style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),)
                                
                            ),
                          );
                        }else if(widget.status_id == 4){
                          return Badge(title: "Need Verification", color: Config().orangePallet,);
                        }else if(widget.status_id == 5){
                          return Badge(title: "Verified", color: Config().bgLock,);
                        }else if(widget.status_id == 6){
                          return Badge(title: "Cancel", color: Color.fromRGBO(172, 172, 172, 1),);
                        }{
                          return SizedBox();
                        }
                        
                      }
                    ),
                    SizedBox(height: 16,),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Duration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                                SizedBox(width: 30,),
                                Text("Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                              ],
                            ),
                            Row(
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (widget.duration == 'full_day') {
                                      return Text("Full Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                    } else{
                                      return Text("Half Day", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                    }
                                  }),
                                SizedBox(width: 30,),
                                Builder(
                                  builder: (context) {
                                    if (widget.duration == "full_day") {
                                      return Text("-", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,));
                                    }else{
                                      return Text("${widget.start_hour.toString().substring(0,5)} - ${widget.finish_hour.toString().substring(0,5)}");
                                    }
                                  }
                            ),
                              ],
                            )
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: 16,),
                    Text("Description", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                    Text("${_wfh![0].description}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,)),
                    SizedBox(height: 16,),
                    Text("links", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromRGBO(0, 0, 0, .64)),),
                    SizedBox(height: 6,),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _wfh![0].request_link!.length,
                      itemBuilder: (context, i) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/mdi_link-variant.png", scale: 2,),
                            SizedBox(width: 10,),
                            Flexible(child: Text("${_wfh![0].request_link![i]['link']}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,))),
                          ],
                        );
                      }
                    )
                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  // -- API --
  Future<void> getDataWfh()async{
    _wfh = await DetailWFHApi.getData(context, widget.id!);
    print('wfh');
    print(_wfh);
  }
}