import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/views/pages/WFH/Approved.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/AddWFH.dart';
import 'package:timsheet_mobile/views/pages/WFH/Cancle.dart';
import 'package:timsheet_mobile/views/pages/WFH/Pending.dart';
import 'package:timsheet_mobile/views/pages/WFH/Reject.dart';
import 'package:timsheet_mobile/views/pages/WFH/Verification.dart';
import 'package:timsheet_mobile/views/pages/WFH/Verified.dart';

class WFH extends StatelessWidget {
  const WFH({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Config().primary,
          title: Text("RWD"),
          centerTitle: true,
          elevation: 0,
          bottom:  TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.redAccent[100],
            labelColor:  Colors.redAccent[100],
            tabs: const [
              Tab(text: "Pending", icon: Icon(Icons.pending)),
              Tab(text: "Approved", icon: Icon(Icons.checklist)),
              Tab(text: "Reject", icon: Icon(Icons.cancel_outlined)),
              Tab(text: "Verification", icon: Icon(Icons.assignment_ind_outlined )),
              Tab(text: "Verified", icon: Icon(Icons.assignment_turned_in_outlined  )),
              Tab(text: "Cancel", icon: Icon(Icons.block_flipped)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Pending(),
            Approved(),
            Reject(),
            Verification(),
            Verified(),
            Cancle()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Config().primary,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddWFH()));
          },
        ),
      ),
    );
  }
}