import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetApi.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetModel.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileApi.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileModel.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/Widget/CardWidget.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';
import 'package:timsheet_mobile/views/TestPage.dart';
import 'package:timsheet_mobile/views/menu/AppCheckExample.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:url_launcher/url_launcher.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String? _fullname;
  Future<dynamic>? _futureFullname;

  // -- profile --
  List<ProfileModel>? _profile;
  Future<dynamic>? _futureProfile;

  // -- empty timesheet
  List<EmptyTimesheetModel>? _emptyTimesheet;
  Future<dynamic>? _futureEmptyTimesheet;
  
  
  Future getDataEmployee()async{
    final storage = new FlutterSecureStorage();
    _fullname = await storage.read(key: 'fullname');
    print(_fullname);
  }

  @override
  void initState(){
    super.initState();
    _futureFullname = getDataEmployee();
    _futureProfile = getProfile();
    _futureEmptyTimesheet = getEmptyTimesheet();
  }

  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    final Uri _url = Uri.parse('https://tasks.office.com/muc.co.id/en-US/Home/Planner/#/mytasks');


    // Future<void> _launchUrl() async {
    //   if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    //     throw Exception('Could not launch $_url');
    //   }
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: width,
                      // height: height/3.6,
                      height: 211,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // colors: [Color.fromRGBO(4, 19, 102, 1), Color.fromRGBO(0, 161, 199, 1), Color.fromRGBO(46, 167, 117, 1)],
                          stops: [0.001, 0.7, 1],
                          colors: [Color.fromRGBO(4, 19, 102, 1), Color.fromRGBO(0, 161, 199, 1), Color.fromRGBO(46, 167, 117, 1)]
                        ),
                        // color: Config().primary,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text('Hallo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),),
                            SizedBox(width: 10),
                            SizedBox(height: 20,),
                            FutureBuilder(
                              future: _futureProfile,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Row(
                                    children: [
                                      _profile![0].url_photo == null ? CircleAvatar(backgroundImage: AssetImage('assets/ahmad.png',),) : CircleAvatar(backgroundImage: NetworkImage("${_profile![0].url_photo}")),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width/1.8,
                                            // color: Colors.red,
                                            child: Text("${_profile![0].fullname}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),)),
                                          Text("${_profile![0].position} ${_profile![0].departement}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),),
                                        ],
                                      ),
                                    ],
                                  );
                                }else{
                                  return Row(
                                    children: [
                                      ShimmerWidget(width: 50, height: 50, isCircle: true),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ShimmerWidget(width: 100, height: 16, isCircle: false),
                                          SizedBox(height: 5,),
                                          ShimmerWidget(width: 80, height: 12, isCircle: false)
                                        ],
                                      )
                                    ],
                                  );
                                }
                              }
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: height/24,
                      child: GestureDetector(
                        onTap: ()async{
                          final storage = new FlutterSecureStorage();
                          await storage.deleteAll();
                          Provider.of<MainState>(context, listen: false).changeLogin(false);
                        },
                        // child: Icon(Icons.logout, color: Colors.red,)
                        child: Image.asset("assets/logout.png", scale: 2,),
                      )
                    ),
                    Positioned(
                      right: 40,
                      top: height/9,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage() ));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppCheckExample()));
                          // void _showModalBottomSheet(BuildContext context) {
                        },
                        child: Image(image: AssetImage('assets/weather_sun.png',), width: 60,))
                    ),
                  ],
                ),
                Container(
                  height: 55,
                  // color: Colors.red,
                ),
                Container(
                  width: width,
                  height: 10,
                  color: Config().line,
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset("assets/timesheet_inactive.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("Empty Timesheet", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FutureBuilder(
                    future: _futureEmptyTimesheet,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1,
                          ), 
                          itemCount: _emptyTimesheet!.length,
                          itemBuilder: (BuildContext context, i){
                            DateTime dt = DateTime.parse(_emptyTimesheet![i].date);
                            String formattedDate = DateFormat("dd \n MMMM").format(dt);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: _emptyTimesheet![i].status == "open" ? Config().bgLock : Config().redPallet,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          color: Color.fromRGBO(0, 0, 0, 0.25),
                                          offset: Offset(0, 4))
                                    ] 
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _emptyTimesheet![i].status == "open" ? Icon(Icons.lock_open_outlined, color: Colors.white,) : Icon(Icons.lock_outline, color: Colors.white,),
                                        Text("$formattedDate", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),)
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          }
                        );
                      }else{
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1,
                          ), 
                          itemCount: 5,
                          itemBuilder: (BuildContext context, i){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              child: Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                  ),
                            );
                          }
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                ),
                              SizedBox(width: 6,),
                              Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                ),
                              SizedBox(width: 6,),
                              Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                ),
                              SizedBox(width: 6,),
                              Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                ),
                              SizedBox(width: 6,),
                              Shimmer.fromColors(
                                baseColor: Color.fromARGB(255, 235, 235, 235),
                                highlightColor: Colors.white,
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  )
                                ),
                            ],
                          ),
                        );
                      }
                    }
                  ),
                ),
                SizedBox(height: 20,),

                
                Container(
                  width: width,
                  height: 10,
                  color: Config().line,
                ),

                // -- HC Announcement --
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/mdi_announcement.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("HC Announcement", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4))
                            ] 
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage("assets/ahmad.png"),
                            ),
                            title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: -10),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Approve your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                                Text("")
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4))
                          ] 
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/ahmad.png"),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reject your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                              SizedBox(height: 8,),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: Color.fromARGB(255, 199, 199, 199)
                                    )
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text("Masih bisa dikerjakan di lain waktu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,)),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30,),

                // -- OT --
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/OT_inactive.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("Overtime", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4))
                            ] 
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage("assets/ahmad.png"),
                            ),
                            title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Approve your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                                Text("")
                                // SizedBox(height: 8,),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     border: Border(
                                //       left: BorderSide(
                                //         width: 2,
                                //         color: Color.fromARGB(255, 199, 199, 199)
                                //       )
                                //     )
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 4),
                                //     child: Text("Masih bisa dikerjakan di lain waktu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,)),
                                //   )
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4))
                          ] 
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/ahmad.png"),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reject your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                              SizedBox(height: 8,),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 2,
                                      color: Color.fromARGB(255, 199, 199, 199)
                                    )
                                  )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Text("Masih bisa dikerjakan di lain waktu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,)),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // -- RWD --
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/rwd_inactive.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("RWD", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4))
                            ] 
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage("assets/ahmad.png"),
                            ),
                            title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            subtitle: Text("Approve your RWD plan created on January, 28 2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 4))
                          ] 
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/ahmad.png"),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                              Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                            ],
                          ),
                          // trailing: Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          subtitle: Text("Reject your RWD plan created on January, 28 2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10,)












                // ---- end ----
                
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, top: 10),
                //   child: Text("Announcement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(221, 32, 32, 32)),),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: ListView(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: [
                //       CardArticle(width: width), 
                //       CardArticle(width: width), 
                //       CardArticle(width: width), 
                //     ],
                //   ),
                // )
              ],
            ),
            Container(
              // color: Colors.red,
              height: height,
            ),
            Positioned(
              top: 135,
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: Text('Quick Access',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
                  ),
                  Container(
                    height: 90,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: const [
                        // CardWidget(title: "Overtime Plan", total: 3, img: "mdi_briefcase-clock.png",),
                        CardWidget(title: "Unlock Request for OT Plan", total: 5, img: "ic_outline-lock-open.png",),
                        CardWidget(title: "Unlock Request for Timesheet", total: 1, img: "mdi_calendar-lock-open-outline.png",),
                        // CardWidget(title: "Total Overtime", total: 5, img: "mdi_briefcase-clock.png",),
                        // CardWidget(title: "RWD", total: 5, img: "carbon_laptop.png",),
                        // CardWidget(title: "Leave", total: 5, img: "mdi_exit-run.png",),
                        CardWidget(title: "Check\nHoliday", total: 5, img: "material-symbols_holiday-village-outline.png",),
                        CardWidget(title: "My\nSummary", total: 5, img: "ic_baseline-menu.png",),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  // -- API --
  Future getProfile()async{
    _profile = await ProfileApi.getDataAssignment(context);
    print(_profile);
  }

  // -- get Empty timesheet --
  Future<void> getEmptyTimesheet()async{
    _emptyTimesheet = await EmptyTimesheetApi.getDataApi(context, 575);
    print("empty timesheet");
    print(_emptyTimesheet);
  }
}

