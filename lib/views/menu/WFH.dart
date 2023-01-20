import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timsheet_mobile/Config/Config.dart';

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
          title: Text("WFH"),
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
              Tab(text: "Cancle", icon: Icon(Icons.block_flipped)),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Config().line))
              ),
              child: ListTile(
                title: Text("Decription of your work"),
                subtitle: Text("Full Day"),
                trailing: Text("20-01-2023", style: TextStyle(fontSize: 11, color: Colors.grey),),
              ),
            );
          },
        )
      ),
    );
  }
}