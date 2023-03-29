
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSampleData{
  ChartSampleData(double x, double y){
    seconds = x;
    yValue = y;
  }
  late double seconds;
  late double yValue;
}
List<ChartSampleData> chartData = <ChartSampleData>[
  ChartSampleData(0, 1.2),
  ChartSampleData(0.1, 1.12),
  ChartSampleData(0.2, 1.08),
  ChartSampleData(0.3, 1.12),
  ChartSampleData(0.4, 1.1),
  ChartSampleData(0.5, 1.12),
  ChartSampleData(0.6, 1.1),
  ChartSampleData(0.7, 1.12),
  ChartSampleData(0.8, 1.16),
  ChartSampleData(0.9, 1.1),
  ChartSampleData(1.0, 1.2),
  ChartSampleData(1.1, 1.12),
  ChartSampleData(1.2, 1.08),
  ChartSampleData(1.3, 1.12),
  ChartSampleData(1.4, 1.1),
  ChartSampleData(1.5, 1.12),
  ChartSampleData(1.6, 1.1),
  ChartSampleData(1.7, 1.12),
  ChartSampleData(1.8, 1.16),
  ChartSampleData(1.9, 1.1),
  ChartSampleData(2.0, 1.2),
  ChartSampleData(2.1, 1.12),
  ChartSampleData(2.2, 1.08),
  ChartSampleData(2.3, 1.12),
  ChartSampleData(2.4, 1.1),
  ChartSampleData(2.5, 1.12),
  ChartSampleData(2.6, 1.1),
  ChartSampleData(2.7, 1.12),
  ChartSampleData(2.8, 1.16),
  ChartSampleData(3, 1.2),
  ChartSampleData(3.1, 1.12),
  ChartSampleData(3.2, 1.08),
  ChartSampleData(3.3, 1.12),
  ChartSampleData(3.4, 1.1),
  ChartSampleData(3.5, 1.12),
  ChartSampleData(3.6, 1.1),
  ChartSampleData(3.7, 1.12),
  ChartSampleData(3.8, 1.16),
  ChartSampleData(4, 1.2),
  ChartSampleData(4.1, 1.12),
  ChartSampleData(4.2, 1.08),
  ChartSampleData(4.3, 1.12),
  ChartSampleData(4.4, 1.1),
  ChartSampleData(4.5, 1.12),
  ChartSampleData(4.6, 1.1),
  ChartSampleData(4.7, 1.12),
  ChartSampleData(4.8, 1.16),
  ChartSampleData(5, 1.2),
  ChartSampleData(5.1, 1.12),
  ChartSampleData(5.2, 1.08),
  ChartSampleData(5.3, 1.12),
  ChartSampleData(5.4, 1.1),
  ChartSampleData(5.5, 1.12),
  ChartSampleData(5.6, 1.1),
  ChartSampleData(5.7, 1.12),
  ChartSampleData(5.8, 1.16),
  ChartSampleData(5.9, 1.1),
  ChartSampleData(6, 1.2),
  ChartSampleData(6.1, 1.12),
  ChartSampleData(6.2, 1.08),
  ChartSampleData(6.3, 1.12),
  ChartSampleData(6.4, 1.1),
  ChartSampleData(6.5, 1.12),
  ChartSampleData(6.6, 1.1),
  ChartSampleData(6.7, 1.12),
  ChartSampleData(6.8, 1.16)
];

class EmptyPlot extends StatefulWidget {
  const EmptyPlot({Key? key}) : super(key: key);

  @override
  State<EmptyPlot> createState() => EmptyPlotState();
}

class EmptyPlotState extends State<EmptyPlot> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 8,
          decoration:  BoxDecoration(
            boxShadow:  [BoxShadow(color: Colors.blueGrey.shade400, spreadRadius: 2)],
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(7.0), bottomLeft: Radius.circular(7.0)),
            color: Colors.blueGrey.shade900,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.blueGrey.shade700, borderRadius: const BorderRadius.only(topLeft: Radius.circular(7.0))),
                alignment: Alignment.center,
                height:30,
                width: MediaQuery.of(context).size.width / 8,
                child: Text("Empty plot", style: TextStyle(fontSize: 15, color: Colors.white, backgroundColor: Colors.blueGrey.shade700, ),),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      title: Container(
                        alignment: Alignment.center,
                        child: const Text('no channel for this plot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 14),),
                      )
                    )
                  ]
                )
              )
            ]
          )
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width / 8) * 7 - 40,
          height: MediaQuery.of(context).size.height / 4,
          child: SfCartesianChart(
            margin: const EdgeInsets.only(bottom:10, left: 1),
            plotAreaBorderWidth: 0,
            primaryXAxis: NumericAxis(
              majorTickLines: const MajorTickLines( size: 0, width: 0 ),
              majorGridLines: const MajorGridLines(width: 0, dashArray: [1,7]),
              axisLine: const AxisLine(width:0),
              labelStyle: const TextStyle(fontSize: 0),
              tickPosition: TickPosition.inside,
              labelPosition: ChartDataLabelPosition.inside,
              axisBorderType: AxisBorderType.rectangle,
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines( size: 0, width: 0 ),
              majorGridLines: const MajorGridLines(width: 0.5, dashArray: [1,7]),
              axisLine: const AxisLine(width:0),
              labelStyle: const TextStyle(fontSize: 10),
              tickPosition: TickPosition.inside,
              labelPosition: ChartDataLabelPosition.inside,
              axisBorderType: AxisBorderType.withoutTopAndBottom,
            ),
            crosshairBehavior: CrosshairBehavior(enable:true, shouldAlwaysShow: true, activationMode: ActivationMode.singleTap ),
            series: <ChartSeries<ChartSampleData, double>>[
              LineSeries<ChartSampleData, double>(
                dataSource: chartData,
                xValueMapper: (ChartSampleData sales, _) => sales.seconds,
                yValueMapper: (ChartSampleData sales, _) => sales.yValue
              )
            ]
          )
        )
      ]
    );
  }
}


class Plot extends StatefulWidget {
  const Plot({Key? key}) : super(key: key);

  @override
  State<Plot> createState() => PlotState();
}

// TODO: implement drag and drop (accepts channel to display)
class PlotState extends State<Plot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:1, right: 20, left:20 ),
      width: MediaQuery.of(context).size.width / 6,
      height:MediaQuery.of(context).size.height / 4.53,
      decoration:  BoxDecoration(
        boxShadow:  [BoxShadow(color: Colors.blueGrey.shade400, spreadRadius: 1),],
        borderRadius: BorderRadius.circular(6.0),
        color: const Color.fromRGBO(18, 18, 18, 1),
      ),
    child: const EmptyPlot());
    //   child: DragTarget<EmptyPlot> (builder: (context, candidateItems, rejectedItems) {
    //   return Plot(
    //     // hasItems: customer.items.isNotEmpty,
    //     // highlighted: candidateItems.isNotEmpty,
    //     // customer: customer,
    //   );
    // },
    // onAccept: (item) {
    //   // _itemDroppedOnCustomerCart(
    //   // item: item,
    //   // customer: customer,
    // }));
    //
  }
}


class TelemetryPlot extends StatefulWidget {
  const TelemetryPlot({Key? key}) : super(key: key);

  @override
  State<TelemetryPlot> createState() => _TelemetryPlotState();
}

class _TelemetryPlotState extends State<TelemetryPlot> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


