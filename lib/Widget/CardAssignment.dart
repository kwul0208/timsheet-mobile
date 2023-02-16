import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';
import 'package:timsheet_mobile/views/pages/Timsheet/ScopeAsignment.dart';

class CardAssignment extends StatelessWidget {
  const CardAssignment({
    Key? key,
    required this.width, this.companies_name, this.name_service, this.year, this.ope, this.assign_numbber, this.scope, this.proposal_id, this.service_id, this.serviceused_id, this.i
  }) : super(key: key);

  final width;
  final String? companies_name; 
  final String? name_service;
  final String? year;
  final String? ope;
  final String? assign_numbber;
  final String? scope;
  final int? proposal_id;
  final int? service_id;
  final num? serviceused_id;
  final int? i;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Provider.of<TimesheetState>(context, listen: false).changeAssignmentIds([proposal_id, service_id, serviceused_id]);
        Provider.of<TimesheetState>(context, listen: false).changeAssignment(companies_name!, name_service!);
        Provider.of<TimesheetState>(context, listen: false).changeIndexS(serviceused_id);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: [
            Container(
              width: width,
              // height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      color: Color.fromARGB(255, 189, 189, 189),
                      offset: Offset(0, 5))
                ] //
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${companies_name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    SizedBox(height: 6,),
                    name_service == '' ? 
                    Text(" -") :
                    Text("${name_service}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Config().primary),),
                    SizedBox(height: 5),
                    SizedBox(height: 7),
                    Text("Assignment Number:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text("${assign_numbber}"),
                    SizedBox(height: 10,),
                    Consumer<TimesheetState>(
                      builder: (context, data, _) {
                        if (data.indexA == i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("OPE: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Text("$ope"),
                              SizedBox(height: 10),
                              Text("Scope:",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Text("$scope")
                            ],
                          );
                        }else{
                          return SizedBox();
                        }
                      }
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Consumer<TimesheetState>(
                        builder: (context, data, _) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(20),
                              border: Border.all(color:Config().primary,width: 2)),
                            child: GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  if (data.indexA == i) {
                                    Provider.of<TimesheetState>(context, listen: false).changeIndexA(null);
                                  } else {
                                    Provider.of<TimesheetState>(context, listen: false).changeIndexA(i);                            }
                                  Provider.of<TimesheetState>(
                                          context,
                                          listen: false)
                                      .changeRefresh();
                                  // });
                                },
                                child:data.indexA == i
                                  ? Icon(
                                      Icons
                                          .keyboard_arrow_up_rounded,
                                      color: Config()
                                          .primary,
                                      size: 22,
                                    )
                                  : Icon(
                                      Icons
                                          .keyboard_arrow_down_rounded,
                                      color: Config()
                                          .primary,
                                      size: 22,
                                    )));
                        }
                      ),
                    )
                                                                
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: (){
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => ScopeAssignment(scope: scope,)));
                    //       },
                    //       child: Text("View Scope >>", style: TextStyle(color: Config().primary),)
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: (){
                    //         Provider.of<TimesheetState>(context, listen: false).changeAssignmentIds([proposal_id, service_id, serviceused_id]);
                    //         Provider.of<TimesheetState>(context, listen: false).changeAssignment(companies_name!, name_service!);
                    //         Navigator.pop(context);
                    //       }, 
                    //       child: Text("Get")
                    //     )
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
            Consumer<TimesheetState>(
              builder: (context, data, _) {
                if (data.indexS == serviceused_id) {
                  return Positioned(
                    right: 10,
                    child: Icon(Icons.check, color: Config().primary, size: 30,));
                }else{
                  return SizedBox();
                }
              }
            )
          ],
        ),
      ),
    );
  }
}