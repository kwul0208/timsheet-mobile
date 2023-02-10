import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileApi.dart';
import 'package:timsheet_mobile/Models/Profile/ProfileModel.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/Widget/CardWidget.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';
import 'package:timsheet_mobile/views/TestPage.dart';
import 'package:timsheet_mobile/views/menu/AppCheckExample.dart';
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
                      height: height/3,
                      decoration: BoxDecoration(
                        color: Config().primary,
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
                            SizedBox(height: 10,),
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
                                          Text("${_profile![0].fullname}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
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
                      top: height/20,
                      child: GestureDetector(
                        onTap: ()async{
                          final storage = new FlutterSecureStorage();
                          await storage.deleteAll();
                          Provider.of<MainState>(context, listen: false).changeLogin(false);
                        },
                        child: Icon(Icons.logout, color: Colors.red,)
                      )
                    ),
                    Positioned(
                      right: 10,
                      top: height/10,
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage() ));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppCheckExample()));
                        },
                        child: Image(image: AssetImage('assets/weather_sun.png',), width: 60,))
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  // color: Colors.red,
                ),
                Container(
                  width: width,
                  height: 10,
                  color: Config().line,
                ),
                
                // Linkify(
                //   onOpen: (link) async {
                //     if (await canLaunch('https://cretezy.com')) {
                //         await launch('https://cretezy.com');
                //       } else {
                //         throw 'Could not launch $link';
                //       }
                //   },
                //   text: "Made by https://cretezy.com",
                //   style: TextStyle(color: Colors.yellow),
                //   linkStyle: TextStyle(color: Colors.red),
                // ),
                // ElevatedButton(
                //   onPressed: _launchUrl,
                //   child: Text('external'),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 10),
                  child: Text("Announcement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color.fromARGB(221, 32, 32, 32)),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CardArticle(width: width), 
                      CardArticle(width: width), 
                      CardArticle(width: width), 
                    ],
                  ),
                )
              ],
            ),
            Container(
              // color: Colors.red,
              height: height,
            ),
            Positioned(
              top: height/5.5,
              left: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text('Today Sumary',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
                  ),
                  Container(
                    height: 140,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: const [
                        CardWidget(title: "Unlock Request for Timesheet", total: 1, icon: Icons.meeting_room_outlined,),
                        CardWidget(title: "Overtime Plan", total: 3, icon: Icons.work_history,),
                        CardWidget(title: "Unlock for OT Plan", total: 5, icon: Icons.lock_clock_outlined ,),
                        CardWidget(title: "Total Overtime", total: 5, icon: Icons.work_history,),
                        CardWidget(title: "RWD", total: 5, icon: Icons.laptop,),
                        CardWidget(title: "Leave", total: 5, icon: Icons.exit_to_app_outlined,),
                        CardWidget(title: "Holiday", total: 5, icon: Icons.holiday_village_outlined,),
                        CardWidget(title: "Other Summary", total: 5, icon: Icons.menu,),

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
}

