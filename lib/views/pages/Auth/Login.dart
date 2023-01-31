import 'dart:convert';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/auth/MainState.dart';
import 'package:timsheet_mobile/main.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // initial dependecy
  final storage = new FlutterSecureStorage();


  // view
  bool _loadBtn = false;
  bool _isObscure = true;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: height/4),
            Image(
              image: AssetImage('assets/logo-muc-tab.png'),
              width: width / 2,
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      // enabled: false,
                      decoration: InputDecoration(
                        label: Text("Username"),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: .0, horizontal: 10.0),
                        fillColor: Colors.transparent,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is requied!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: .0, horizontal: 10.0),
                        fillColor: Colors.transparent,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Config().primary,
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: _loadBtn == false
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loadBtn = !_loadBtn;
                                });
                                // await Future.delayed(
                                //     const Duration(seconds: 2));
                                await postLogin(_emailController.text, _passwordController.text).then((value){
                                  setState(() {
                                    _loadBtn = !_loadBtn;
                                  });
                                  if(value['status'] == true){
                                    Provider.of<MainState>(context, listen: false).changeLogin(true);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
                                  } else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("${value['message']}"),
                                    ));
                                  }
                                });                                
                              }
                            }
                          : null,
                      child: _loadBtn == false
                          ? Text(
                              'Login',
                              style: TextStyle(fontSize: 24),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1,),
            SizedBox(height: 1,)
          ],
        ),
      ),
    );
  }

  // --- APi ----

  Future postLogin(username, password)async{
    print([username, password]);
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request = http.Request('POST', Uri.parse('http://103.115.28.155:2281/mucnet/api/auth/employee'));
    request.bodyFields = {
      'username': username,
      'password': password
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var x = await response.stream.bytesToString();
      Map data = jsonDecode(x);
      print(data.runtimeType);
      print(data);
      if (data['status'] == 'success') {
        await storage.write(key: 'employees_id', value: data['employees_id'].toString());
        await storage.write(key: 'fullname', value: data['fullname'].toString());
        await storage.write(key: 'departement_id', value: data['departement_id'].toString());
        await storage.write(key: 'jobtitle_id', value: data['jobtitle_id'].toString());
        await storage.write(key: 'is_consultant', value: data['is_consultant'].toString());
        await storage.write(key: 'nik', value: data['nik'].toString());
        await storage.write(key: 'signed_in', value: data['signed_in'].toString());
        return {"status": true, "message": "success"};
      }else{
        return {"status": false, "message": "${data['message']}"};
      }
    }
    else {
      return {"status": false, "message": "server error!, ${response.reasonPhrase}"};
    }

  }
}
