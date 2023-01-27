import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';


class ScopeAssignment extends StatelessWidget {
  const ScopeAssignment({super.key, this.scope});

  final String? scope;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Scope Detail",
                style: TextStyle(color: Colors.black, fontSize: 18)),
            centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('${scope}'),
        ),
      ),
    );
  }
}