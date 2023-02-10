import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timsheet_mobile/Config/Config.dart';
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
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Config().primary,
            title: Text("Overtime"),
            centerTitle: true,
            elevation: 0,
            bottom:  TabBar(
              // isScrollable: true,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.black,
              labelColor:  Colors.black,
              tabs:  [
                Tab(text: "Plan", icon: Icon(Icons.more_time)),
                Tab(text: "Check", icon: Icon(Icons.format_list_bulleted_outlined)),
              ],
            ),
          ),
          body: TabBarView(
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddOT()));
        },
            ),
      ),
    );
  }
}