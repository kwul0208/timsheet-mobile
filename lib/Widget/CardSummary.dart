import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Timesheet/TimesheetState.dart';

class cardSummary extends StatelessWidget {
  const cardSummary({
    Key? key,
    required this.width,
    required this.chartData,
    this.working_time,
    this.over_time,
    this.ishoma,
    this.chargeable,
    this.office_administration,
    this.training
  }) : super(key: key);

  final width;
  final List<Data> chartData;
  final String? working_time;
  final String? over_time;
  final String? ishoma;
  final String? chargeable;
  final String? office_administration;
  final String? training;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Color.fromARGB(255, 221, 221, 221),
              offset: Offset(0, 5))
        ] //
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Summary of Working Time", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Working Time", style: TextStyle(color: Config().blue2, fontWeight: FontWeight.w700, fontSize: 14),),
                    Text("${working_time.toString().substring(0,5)}", style: TextStyle(fontSize: 14),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Over Time", style: TextStyle(color: Config().blue2, fontWeight: FontWeight.w700, fontSize: 14),),
                    Text("${over_time.toString().substring(0,5)}", style: TextStyle(fontSize: 14),)
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),

            SizedBox(
              height: 20,
              child: HorizontalBarChart(
                data: chartData,
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Details", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                GestureDetector(
                  onTap: (){
                    // Provider.of<TimesheetState>(context, listen: false).showDetailSummary();
                  },
                  child: Image.asset("assets/details_summary.png", scale: 1.7,)
                )
              ],
            ),
            SizedBox(height: 14,),

            Consumer<TimesheetState>(
              builder: (context, data, _) {
                if (data.showDS == false) {
                  return SizedBox();
                }else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Chargeable
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(137, 69, 170, 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Chargeable", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white, size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${chargeable.toString().substring(0,5)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6),

                      // -- ISHOMA
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(7, 84, 130, 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ISHOMA", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white, size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${ishoma.toString().substring(0,5)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6),

                      // -- Office AD
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(242, 154, 118, 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Office Administration", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white, size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${office_administration.toString().substring(0,5)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6),

                      // -- Training
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 204, 103, 1),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Training", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.white, size: 20,),
                                  SizedBox(width: 5,),
                                  Text("${training.toString().substring(0,5)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalBarChart extends StatelessWidget {
  final List<Data> data;
  final double gap;

  const HorizontalBarChart({
    Key? key,
    required this.data,
    this.gap = .02,
  }) : super(key: key);

  List<double> get processedStops {
    double totalGapsWith = gap * (data.length - 1);
    double totalData = data.fold(0, (a, b) => a + b.units);
    return data.fold(<double>[0.0], (List<double> l, d) {
      l.add(l.last + d.units * (1 - totalGapsWith) / totalData);
      l.add(l.last);
      l.add(l.last + gap);
      l.add(l.last);
      return l;
    })
      ..removeLast()
      ..removeLast()
      ..removeLast();
  }

  List<Color> get processedColors {
    return data.fold(
        <Color>[],
        (List<Color> l, d) => [
              ...l,
              d.color,
              d.color,
              Colors.transparent,
              Colors.transparent,
            ])
      ..removeLast()
      ..removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: processedStops,
          colors: processedColors,
        ),
      ),
    );
  }
}

class Data {
  final double units;
  final Color color;

  Data({required this.units, required this.color});
}