import "package:flutter/material.dart";
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:timsheet_mobile/Config/Config.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

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

        List<_SalesData> data = [
          _SalesData('Chargable', 10),
          _SalesData('OA', 28),
          _SalesData('Ishoma', 34),
          _SalesData('Training', 32),
          _SalesData('Suport', 40)
        ];

        List<_SalesData2> data2 = [
          _SalesData2('Chargable', 20),
          _SalesData2('OA', 30),
          _SalesData2('Ishoma', 20),
          _SalesData2('Training', 90),
          _SalesData2('Suport', 50)
        ];

        return Scaffold(
            body: Column(
              children: [
                SizedBox(height: 200,),

            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: Legend(isVisible: true, position: LegendPosition.top),
              onLegendTapped: (val){
                print('ok');
              },
              onLegendItemRender: null,
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                SplineSeries<_SalesData, String>(
                  color: Config().primary2,
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: '2022',
                    yAxisName: 'y',
                    xAxisName: "x",
                    // Enable data label
                    // dataLabelSettings: DataLabelSettings(isVisible: true)
                  ),

                SplineSeries<_SalesData2, String>(
                  color: Config().orangePallet,
                    dataSource: data2,
                    xValueMapper: (_SalesData2 sales, _) => sales.year,
                    yValueMapper: (_SalesData2 sales, _) => sales.sales,
                    name: '2023',
                    yAxisName: "y",
                    xAxisName: "x"
                    // Enable data label
                    // dataLabelSettings: DataLabelSettings(isVisible: true)
                  )
              ]),


              SfSparkLineChart.custom(
                //Enable the trackball
                // trackball: SparkChartTrackball(
                    // activationMode: SparkChartActivationMode.tap),
                //Enable marker
                // marker: SparkChartMarker(
                    // displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                // labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
              ],
            )
            );
        }
    }
    class _SalesData {
      _SalesData(this.year, this.sales);

      final String year;
      final double sales;
    }

    class _SalesData2 {
      _SalesData2(this.year, this.sales);

      final String year;
      final double sales;
    }