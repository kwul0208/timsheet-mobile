import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/views/pages/Overtime/CRUD/AddOT.dart';
import 'package:timsheet_mobile/views/pages/Overtime/menu/Check.dart';
import 'package:timsheet_mobile/views/pages/Overtime/menu/Plan.dart';

class Overtime extends StatelessWidget {
  const Overtime({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140.0),
          child: AppBar(
            
              automaticallyImplyLeading: false,
              backgroundColor: Config().primary,
              title: Column(
                children: [
                  Text("Overtime", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: "Inter")),
                ],
              ),
              centerTitle: true,
              elevation: 0,
              bottom:  TabBar(
                // indicatorWeight: 40,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.transparent,
                labelColor:  Colors.black,
                onTap: (val){
                  Provider.of<OvertimeState>(context, listen: false).changeIndexO(val);
                },
                tabs:  [
                  Consumer<OvertimeState>(
                    builder: (context, data, _) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4,),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          width: 62,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: data.indexO == 0 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                          ),
                          child: Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data.indexO == 0 ? Image.asset("assets/plan_active.png", scale: 2,) : Image.asset("assets/plan_inactive.png", scale: 2,),
                                Text("Plan", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: data.indexO == 0 ? Colors.black : Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  Consumer<OvertimeState>(
                    builder: (context, data, _) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          width: 62,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: data.indexO == 1 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                          ),
                          child: Tab(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data.indexO == 1 ? Image.asset("assets/check_active.png", scale: 2,) : Image.asset("assets/check_inactive.png", scale: 2,),
                                Text("Check", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: data.indexO == 1 ? Colors.black : Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
        ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Plan(),
              Check()
            ],
          ),
      //   body: ListView.builder(
      //     itemCount: 15,
      //     itemBuilder: (context, index) {
      //       return Container(
      //         decoration: BoxDecoration(
      //           border: Border(bottom: BorderSide(width: 1, color: Config().line))
      //         ),
      //         child: ListTile(
      //           title: Text("Decription of your Overtime"),
      //           subtitle: Text("Time: 20:00 - 22:00"),
      //           trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
      //         ),
      //       );
      //     },
      //   ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Config().primary,
        child: Icon(Icons.add),
        onPressed: (){
          Provider.of<TimesheetState>(context, listen: false).reset();
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddOT()));
        },
            ),
      ),
    );
  }
}