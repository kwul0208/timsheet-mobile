import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/WFH/WFHState.dart';
import 'package:timsheet_mobile/views/pages/WFH/Approved.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/AddWFH.dart';
import 'package:timsheet_mobile/views/pages/WFH/Cancle.dart';
import 'package:timsheet_mobile/views/pages/WFH/Pending.dart';
import 'package:timsheet_mobile/views/pages/WFH/Reject.dart';
import 'package:timsheet_mobile/views/pages/WFH/Verification.dart';
import 'package:timsheet_mobile/views/pages/WFH/Verified.dart';

class WFH extends StatefulWidget {
  const WFH({super.key});

  @override
  State<WFH> createState() => _WFHState();
}

class _WFHState extends State<WFH> {

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      Provider.of<WFHState>(context, listen: false).changeIndexO(0);
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Config().primary,
            title: Text("RWD", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, fontFamily: "Inter")),
            centerTitle: true,
            elevation: 0,
            bottom:  TabBar(
              isScrollable: true,
              // unselectedLabelColor: Colors.white,
              // indicatorColor: Colors.redAccent[100],
              // labelColor:  Colors.redAccent[100],
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.transparent,
              labelColor:  Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 10),
              labelPadding: EdgeInsets.symmetric(horizontal: 2),
              onTap: (val){
                  Provider.of<WFHState>(context, listen: false).changeIndexO(val);
                },
              tabs: [
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 0 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 0 ? Image.asset("assets/pending_active.png", scale: 2,) : Image.asset("assets/pending_inactive.png", scale: 2,),
                              Text("Pending", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 0 ? Colors.black : Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 1 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 1 ? Image.asset("assets/approved_active.png", scale: 2,) : Image.asset("assets/approved_inactive.png", scale: 2,),
                              Text("Approved", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 1 ? Colors.black : Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 2 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 2 ? Image.asset("assets/nv_active.png", scale: 2.4,) : Image.asset("assets/nv_inactive.png", scale: 2,),
                              Text("Need Verification", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 2 ? Colors.black : Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 3 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 3 ? Image.asset("assets/verified_active.png", scale: 2.3,) : Image.asset("assets/verified_inactive.png", scale: 2,),
                              SizedBox(height: 4,),
                              Text("Verified", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 3 ? Colors.black : Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 4 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 4 ? Image.asset("assets/reject_active.png", scale: 2.3,) : Image.asset("assets/reject_inactive.png", scale: 2,),
                              SizedBox(height: 2,),
                              Text("Rejected", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 4 ? Colors.black : Colors.white),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                Consumer<WFHState>(
                  builder: (context, data, _) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4,),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        width: 133,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: data.indexO == 5 ? Color.fromRGBO(255, 255, 255, 0.83) : Colors.transparent
                        ),
                        child: Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.indexO == 5 ? Image.asset("assets/cancle_active.png", scale: 2.3,) : Image.asset("assets/cancle_inactive.png", scale: 2,),
                              SizedBox(height: 4,),
                              Text("Cancel", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: data.indexO == 5 ? Colors.black : Colors.white),)
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
            Pending(),
            Approved(),
            Verification(),
            Verified(),
            Reject(),
            Cancle()
          ],
        ),
        floatingActionButton: Consumer<WFHState>(
          builder: (context, data, _) {
            if (data.indexO == 0) {
              return FloatingActionButton(
                backgroundColor: Config().primary,
                child: Icon(Icons.add),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddWFH()));
                },
              );
            }else{
              return SizedBox();
            }
          }
        ),
      ),
    );
  }
}