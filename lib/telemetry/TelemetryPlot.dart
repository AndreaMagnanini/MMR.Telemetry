
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'channel.dart';
class TelemetrySeries{
  TelemetrySeries(double this.t, double this.y);
  double? t;
  double? y;
}
class TelemetryPlot extends StatefulWidget {
  const TelemetryPlot({Key? key}) : super(key: key);

  @override
  State<TelemetryPlot> createState() => _TelemetryPlotState();
}

class _TelemetryPlotState extends State<TelemetryPlot> {

  List<Channel> channels = [];
  final List<Color> colors = [
    Colors.deepOrangeAccent.shade400,
    Colors.amberAccent.shade400,
    Colors.lightGreenAccent.shade400,
    Colors.purpleAccent,
    Colors.lightBlueAccent.shade400,
    Colors.orangeAccent.shade700,
    Colors.cyanAccent.shade100,
    Colors.amber.shade100
  ];
  String? unit;
  List<TelemetrySeries> series = [];
  List<ChartSeries<TelemetrySeries, double>> lineSeries = [];

  @override
  Widget build(BuildContext context) {
    return DragTarget<List<Channel>> (
        builder: (context, candidateItems, rejectedItems) {
          return Container(
            margin: const EdgeInsets.only(top:1, right: 20, left:20 ),
            width: MediaQuery.of(context).size.width / 6,
            height:MediaQuery.of(context).size.height / 4.53,
            decoration:  BoxDecoration(
              boxShadow:  [BoxShadow(color: Colors.blueGrey.shade400, spreadRadius: 1),],
              borderRadius: BorderRadius.circular(6.0),
              color: const Color.fromRGBO(18, 18, 18, 1),
            ),
            child: Row(
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
                          series: series,)

                      )

                ]
            )
          );
        },
        onAccept: (data) {
          // _itemDroppedOnCustomerCart(
          // item: item,
          // customer: customer,
        });
  }

  void addChannel(Channel newChannel){
    setState(() {
      if(channels.isEmpty){
        unit = newChannel.unit;
        channels.add(newChannel);

        lineSeries.add(LineSeries<TelemetrySeries, double>(
            color: assignColor(newChannel),
            dataSource: series,
            xValueMapper: (TelemetrySeries series, _) => series.t,
            yValueMapper: (TelemetrySeries series, _) => series.y
        ));
      }
      else{
        if (channels.length == 8){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Maximum line plot per chart reached.')));
          return;
        }
        if(newChannel.unit == unit){
          channels.add(newChannel);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Channels in the same plot must all have the same unit.')));
        }
      }
    }
    );
  }
  void remove(Channel channelName){
    setState(() {
      channels.remove(channels.firstWhere((element) => element.name == channelName));
    });
  }

  Color assignColor(Channel newChannel){
    return colors[channels.indexOf(newChannel)];
  }
}


