import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/Widget/CardArticle.dart';
import 'package:timsheet_mobile/Widget/CardWidget.dart';
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
  
  Future getDataEmployee()async{
    final storage = new FlutterSecureStorage();
    _fullname = await storage.read(key: 'fullname');
    print(_fullname);
  }

  @override
  void initState(){
    super.initState();
    _futureFullname = getDataEmployee();
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
                            Row(
                              children: [
                                Text('Hallo!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: ()async{
                                    final storage = new FlutterSecureStorage();
                                    await storage.deleteAll();
                                    Provider.of<MainState>(context, listen: false).changeLogin(false);
                                  },
                                  child: Icon(Icons.logout, color: Colors.red,)
                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                CircleAvatar(backgroundImage: AssetImage('assets/ahmad.png',),),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                      future: _futureFullname,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        return Text("${_fullname}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),);
                                      }
                                    ),
                                    Text("Job Position", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: height/15,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AppCheckExample()));
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
                        CardWidget(title: "Empty Timsheet", total: 3, icon: Icons.calendar_month,),
                        CardWidget(title: "Meeting", total: 1, icon: Icons.meeting_room_outlined,),
                        CardWidget(title: "Cuti", total: 5, icon: Icons.insert_emoticon_outlined ,),
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
}

