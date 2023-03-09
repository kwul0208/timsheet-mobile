import "package:flutter/material.dart";
import 'package:timsheet_mobile/Config/Config.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final chartData = [
      Data(units: 1, color: const Color.fromRGBO(137, 69, 170, 1)),
      Data(units: 2, color: const Color.fromRGBO(7, 84, 130, 1)),
      Data(units: 4, color: const Color.fromRGBO(242, 154, 118, 1)),
      Data(units: 3, color: const Color.fromRGBO(255, 204, 103, 1)),
    ];

  @override
  void initState(){
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: cardSummary(width: width, chartData: chartData),
        ),
      ),
    );
  }
}

class cardSummary extends StatelessWidget {
  const cardSummary({
    Key? key,
    required this.width,
    required this.chartData,
  }) : super(key: key);

  final width;
  final List<Data> chartData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 400,
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
            Text("Summary of Working Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Working Time", style: TextStyle(color: Config().blue2, fontWeight: FontWeight.w700, fontSize: 16),),
                    Text("10:00", style: TextStyle(fontSize: 16),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Working Time", style: TextStyle(color: Config().blue2, fontWeight: FontWeight.w700, fontSize: 16),),
                    Text("10:00", style: TextStyle(fontSize: 16),)
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
                Text("Details", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                Image.asset("assets/details_summary.png", scale: 1.7,)
              ],
            ),
            SizedBox(height: 14,),
            
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
                    Text("Chargeable", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 20,),
                        SizedBox(width: 5,),
                        Text("02:00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
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
                    Text("ISHOMA", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 20,),
                        SizedBox(width: 5,),
                        Text("02:00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
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
                    Text("Office Administration", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 20,),
                        SizedBox(width: 5,),
                        Text("02:00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
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
                    Text("Training", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 20,),
                        SizedBox(width: 5,),
                        Text("02:00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),),
                      ],
                    ),
                  ],
                ),
              ),
            )
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
