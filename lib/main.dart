import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/views/menu/Dashboard.dart';
import 'package:timsheet_mobile/views/menu/Overtime.dart';
import 'package:timsheet_mobile/views/menu/Timsheet.dart';
import 'package:timsheet_mobile/views/menu/WFH.dart';
import 'package:timsheet_mobile/views/pages/Auth/Login.dart';

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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => TimesheetState())),
      ChangeNotifierProvider(create: ((context) => MainState())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
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

  List<Widget> _children = [Dashboard(), Timesheet(), Overtime(), WFH()];

  @override
  void initState(){
    super.initState();

    checkId();
  }

  Future checkId()async{
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'employees_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children.elementAt(_curentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.task), label: "Timesheet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.work), label: "Overtime"),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "WFH"),
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
