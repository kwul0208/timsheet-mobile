import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Overtime/OvertimeState.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/views/menu/Cuti.dart';
import 'package:timsheet_mobile/views/menu/Dashboard.dart';
import 'package:timsheet_mobile/views/menu/Overtime.dart';
import 'package:timsheet_mobile/views/menu/Timsheet.dart';
import 'package:timsheet_mobile/views/menu/WFH.dart';
import 'package:timsheet_mobile/views/pages/Auth/Login.dart';
import 'package:flutter/services.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => TimesheetState())),
      ChangeNotifierProvider(create: ((context) => MainState())),
      ChangeNotifierProvider(create: ((context) => OvertimeState())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future checkId()async{
    final storage = new FlutterSecureStorage();
    var employees_id = await storage.read(key: 'employees_id');
    print(employees_id);
    if(employees_id != null){
      Provider.of<MainState>(context, listen: false).changeLogin(true);
    }
  }

  @override
  void initState(){
    super.initState();
        checkId();

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter'
      ),
      home: Consumer<MainState>(
        builder: (context, data, _) {
          if (data.isLogin == false) {
            return LoginPage();
          }else{
            return MyHomePage();
          }
        }
      )
      // home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curentIndex = 0;

  void onTapBar(int index) {
    setState(() {
      _curentIndex = index;
    });
  }

  List<Widget> _children = [Dashboard(), WFH(), Timesheet(), Overtime(), Cuti()];

  @override
  void initState(){
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children.elementAt(_curentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Container(child: _curentIndex == 0 ? Image.asset("assets/dashboard_active.png", scale: 2,) : Image.asset("assets/dashboard_inactive.png", scale: 2,)), label: ""),
          BottomNavigationBarItem(
              icon: Container(child: _curentIndex == 1 ? Image.asset("assets/rwd_active.png", scale: 2,) : Image.asset("assets/rwd_inactive.png", scale: 2,)), label: ""),
          BottomNavigationBarItem(
              icon: Container(child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(child: _curentIndex == 2 ? Image.asset("assets/timesheet_active.png", scale: 2,) : Image.asset("assets/timesheet_inactive.png", scale: 2,)),
              )), label: ""),
          BottomNavigationBarItem(icon: Container(child: _curentIndex == 3 ? Image.asset("assets/OT_active.png", scale: 2,) : Image.asset("assets/OT_inactive.png", scale: 2,)), label: ""),
          BottomNavigationBarItem(icon: Container(child: _curentIndex == 4 ? Image.asset("assets/cuti_active.png", scale: 2.2,) : Image.asset("assets/cuti_inactive.png", scale: 2.2,)), label: ""),
        ],
        onTap: onTapBar,
        currentIndex: _curentIndex,
        selectedItemColor: Config().primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
