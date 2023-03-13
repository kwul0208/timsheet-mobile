import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Dashboard/Announcement/AnnouncementApi.dart';
import 'package:timsheet_mobile/Models/Dashboard/Announcement/AnnouncementModel.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetApi.dart';
import 'package:timsheet_mobile/Models/Dashboard/EmptyTimesheetModel.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileApi.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileModel.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/Widget/CardWidget.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerAnnouncement.dart';
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

  // -- Announcement
  List<AnnouncementModel>? _announcement;
  Future<dynamic>? _futureAnnouncement;
  
  
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
    _futureAnnouncement = getAnnouncement();
  }

  
        List<_SalesData> data = [
          _SalesData('Chargable', 10),
          _SalesData('OA', 28),
          _SalesData('Ishoma', 34),
          _SalesData('Training', 32),
          _SalesData('Suport', 40)
        ];

        List<_SalesData2> data2 = [
          _SalesData2('Chargable', 20),
          _SalesData2('OA', 30),
          _SalesData2('Ishoma', 20),
          _SalesData2('Training', 90),
          _SalesData2('Suport', 50)
        ];

  _appBar(height) => PreferredSize(
    preferredSize:  Size(MediaQuery.of(context).size.width, height+180 ),
    child: Stack(
      children: <Widget>[
        Container(
          height: height + 150,
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
                              // width: width/1.8,
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

        Container(),   // Required some widget in between to float AppBar

        Positioned(
          right: 10,
          top: 36,
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
          top: 90,
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage() ));
            },
            child: Image(image: AssetImage('assets/weather_sun.png',), width: 60,))
        ),

        Positioned(
          top: 125,
          left: 0.0,
          bottom: 0.0,
          right: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 10),
                child: Text('Quick Access',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
              ),
              // SizedBox(height: 20,),
              Container(
                height: 90,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children:  [
                    // CardWidget(title: "Overtime Plan", total: 3, img: "mdi_briefcase-clock.png",),
                    CardWidget(title: "Unlock\nOT Plan", total: 5, img: "mdi_clock-plus.png",),
                    CardWidget(title: "Unlock Request for Timesheet", total: 1, img: "mdi_calendar-lock-open-outline.png",),
                    // CardWidget(title: "Total Overtime", total: 5, img: "mdi_briefcase-clock.png",),
                    // CardWidget(title: "RWD", total: 5, img: "carbon_laptop.png",),
                    // CardWidget(title: "Leave", total: 5, img: "mdi_exit-run.png",),
                    CardWidget(title: "Check\nHoliday", total: 5, img: "material-symbols_holiday-village-outline.png",),
                    // CardWidget(title: "My\nSummary", total: 5, img: "ic_baseline-menu.png",),
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Color.fromARGB(221, 180, 180, 180),
                                  offset: Offset(1, 5))
                            ],
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white
                          ),
                          child: Image.asset("assets/Vector.png", scale: 2,),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),

      ],
    ),
  );


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
      appBar: _appBar(AppBar().preferredSize.height),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FutureBuilder(
                    future: _futureEmptyTimesheet,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_emptyTimesheet!.isEmpty) {
                          return Align(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset("assets/no_empty.png", scale: 1.9,),
                                SizedBox(height: 5,),
                                Text("Congratulation!", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                                Text("All your timesheets are filled", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color.fromRGBO(0, 0, 0, 1)),)
                              ],
                            ),
                          );
                        }else{
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
                        }
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/carbon_carbon-for-ibm-product.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("Productivity", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  legend: Legend(isVisible: true, position: LegendPosition.bottom),
                  onLegendTapped: (val){
                    print('ok');
                  },
                  onLegendItemRender: null,
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries>[
                    SplineSeries<_SalesData, String>(
                      color: Config().primary2,
                        dataSource: data,
                        xValueMapper: (_SalesData sales, _) => sales.year,
                        yValueMapper: (_SalesData sales, _) => sales.sales,
                        name: '2022',
                        yAxisName: 'y',
                        xAxisName: "x",
                        // Enable data label
                        // dataLabelSettings: DataLabelSettings(isVisible: true)
                      ),

                    SplineSeries<_SalesData2, String>(
                      color: Config().orangePallet,
                        dataSource: data2,
                        xValueMapper: (_SalesData2 sales, _) => sales.year,
                        yValueMapper: (_SalesData2 sales, _) => sales.sales,
                        name: '2023',
                        yAxisName: "y",
                        xAxisName: "x"
                        // Enable data label
                        // dataLabelSettings: DataLabelSettings(isVisible: true)
                      )
                  ]),

                Container(
                  width: width,
                  height: 10,
                  color: Config().line,
                ),

                // -- HC Announcement --
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Image.asset("assets/mdi_announcement.png", scale: 2,),
                      SizedBox(width: 10,),
                      Text("Announcement", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder(
                    future: _futureAnnouncement,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _announcement!.length > 5 ? 5 : _announcement!.length,
                          itemBuilder: (context, i) {
                            return CardArticle(width: width, date: _announcement![i].date, sender: _announcement![i].sender, message: _announcement![i].message, url_photo: _announcement![i].url_photo, index: i,);
                          }
                        );
                      }else{
                        return ShimmerAnnouncement(width: width);
                      }
                      
                    }
                  ),
                ),

                SizedBox(height: 30,),

                // // -- OT --
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                //   child: Row(
                //     children: [
                //       Image.asset("assets/OT_inactive.png", scale: 2,),
                //       SizedBox(width: 10,),
                //       Text("Overtime", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                //     ],
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: ListView(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(bottom: 10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.white,
                //             boxShadow: [
                //               BoxShadow(
                //                 blurRadius: 5,
                //                 color: Color.fromRGBO(0, 0, 0, 0.25),
                //                 offset: Offset(0, 4))
                //             ] 
                //           ),
                //           child: ListTile(
                //             leading: CircleAvatar(
                //               backgroundImage: AssetImage("assets/ahmad.png"),
                //             ),
                //             title: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                //               Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                //             ],
                //           ),
                //             contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //             subtitle: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text("Approve your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                //                 Text("")
                //                 // SizedBox(height: 8,),
                //                 // Container(
                //                 //   decoration: BoxDecoration(
                //                 //     border: Border(
                //                 //       left: BorderSide(
                //                 //         width: 2,
                //                 //         color: Color.fromARGB(255, 199, 199, 199)
                //                 //       )
                //                 //     )
                //                 //   ),
                //                 //   child: Padding(
                //                 //     padding: const EdgeInsets.only(left: 4),
                //                 //     child: Text("Masih bisa dikerjakan di lain waktu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,)),
                //                 //   )
                //                 // )
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //               blurRadius: 5,
                //               color: Color.fromRGBO(0, 0, 0, 0.25),
                //               offset: Offset(0, 4))
                //           ] 
                //         ),
                //         child: ListTile(
                //           leading: CircleAvatar(
                //             backgroundImage: AssetImage("assets/ahmad.png"),
                //           ),
                //           title: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                //               Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                //             ],
                //           ),
                //           contentPadding: EdgeInsets.symmetric(horizontal: 10),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text("Reject your overtime", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                //               SizedBox(height: 8,),
                //               Container(
                //                 decoration: BoxDecoration(
                //                   border: Border(
                //                     left: BorderSide(
                //                       width: 2,
                //                       color: Color.fromARGB(255, 199, 199, 199)
                //                     )
                //                   )
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(left: 4),
                //                   child: Text("Masih bisa dikerjakan di lain waktu", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,)),
                //                 )
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // SizedBox(height: 30),

                // // -- RWD --
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                //   child: Row(
                //     children: [
                //       Image.asset("assets/rwd_inactive.png", scale: 2,),
                //       SizedBox(width: 10,),
                //       Text("RWD", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)
                //     ],
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: ListView(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(bottom: 10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             color: Colors.white,
                //             boxShadow: [
                //               BoxShadow(
                //                 blurRadius: 5,
                //                 color: Color.fromRGBO(0, 0, 0, 0.25),
                //                 offset: Offset(0, 4))
                //             ] 
                //           ),
                //           child: ListTile(
                //             leading: CircleAvatar(
                //               backgroundImage: AssetImage("assets/ahmad.png"),
                //             ),
                //             title: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                //               Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                //             ],
                //           ),
                //             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //             subtitle: Text("Approve your RWD plan created on January, 28 2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                //           ),
                //         ),
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //               blurRadius: 5,
                //               color: Color.fromRGBO(0, 0, 0, 0.25),
                //               offset: Offset(0, 4))
                //           ] 
                //         ),
                //         child: ListTile(
                //           leading: CircleAvatar(
                //             backgroundImage: AssetImage("assets/ahmad.png"),
                //           ),
                //           title: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Flexible(child: Text("Mahrizal", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                //               Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                //             ],
                //           ),
                //           // trailing: Text("12/02/2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
                //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                //           subtitle: Text("Reject your RWD plan created on January, 28 2023", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(height: 10,)
              ],
            ),
            Container(
              // color: Colors.red,
              height: height,
            ),
          ],
        ),
      )
    );
  }

  // -- API --
  Future getProfile()async{
    _profile = await ProfileApi.getDataAssignment(context);
  }

  // -- get Empty timesheet --
  Future<void> getEmptyTimesheet()async{
    _emptyTimesheet = await EmptyTimesheetApi.getDataApi(context);

  }

  // get Announcement
  Future<void> getAnnouncement()async{
    _announcement = await AnnouncementApi.getDataApi(context);
    print("-- Announcement --");
    print(_announcement);
  }
}

    class _SalesData {
      _SalesData(this.year, this.sales);

      final String year;
      final double sales;
    }

    class _SalesData2 {
      _SalesData2(this.year, this.sales);

      final String year;
      final double sales;
    }


