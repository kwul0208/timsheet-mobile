import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/ScopeAsignment.dart';

class CardAssignment extends StatelessWidget {
  const CardAssignment({
    Key? key,
    required this.width, this.companies_name, this.name_service, this.year, this.ope, this.assign_numbber, this.scope
  }) : super(key: key);

  final width;
  final String? companies_name; 
  final String? name_service;
  final String? year;
  final String? ope;
  final String? assign_numbber;
  final String? scope;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: width,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Color.fromARGB(255, 221, 221, 221),
                offset: Offset(0, 0))
          ] //
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${companies_name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              Divider(),
              // Text("name_service", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              name_service == '' ? 
              Text(" -") :
              Text("${name_service}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("Year: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("${year}")
                    ],
                  ),
                  Row(
                    children: [
                      Text("OPE: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("$ope")
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Text("Assignment Number:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text("${assign_numbber}"),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ScopeAssignment(scope: scope,)));
                    },
                    child: Text("View Scope >>", style: TextStyle(color: Config().primary),)
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Provider.of<TimesheetState>(context, listen: false).changeAssignment(companies_name!, name_service!);
                      Navigator.pop(context);
                    }, 
                    child: Text("Get")
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}