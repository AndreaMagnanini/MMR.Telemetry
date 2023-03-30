
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'channel.dart';
class TelemetrySeries{
  TelemetrySeries(double this.t, double this.y, this.channelName);
  String channelName;
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
  List<List<TelemetrySeries>> series = [];
  List<FastLineSeries<TelemetrySeries, double>> lineSeries = [];

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
                      child: Text(channels.isEmpty ? "Empty plot" : unit!, style: TextStyle(fontSize: 15, color: Colors.white, backgroundColor: Colors.blueGrey.shade700, ),),
                    ),
                    Expanded(
                      child: ListView(
                        children: channels.map((channel) => ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                          leading: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(color: colors[channels.indexOf(channel)], borderRadius: BorderRadius.circular(10))
                          ),
                          trailing:
                            IconButton(onPressed: () => remove(channel.name), icon: const Icon(Icons.delete_sharp, color: Colors.white, size: 18,), padding: EdgeInsets.zero,),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('${channel.name}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 14, )
                            ),
                          )
                        )).toList()
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
                  series: lineSeries,
                )
              )
            ]
          )
        );
      },
      onAccept: (data) {
        addChannel(data);
      }
    );
  }

  void addChannel(List<Channel> newChannel){
    if(channels.isEmpty){
      setState(() {
        unit = newChannel[1].unit;
        channels.add(newChannel[1]);
        List<TelemetrySeries> newList = [];
        for(double value in newChannel[1].values){
          newList.add(TelemetrySeries(newChannel[0].values[newChannel[1].values.indexOf(value)], value, newChannel[1].name));
        }
        series.add(newList);
        lineSeries.add(FastLineSeries<TelemetrySeries, double>(
            key: ValueKey(newChannel[1].name),
            color: assignColor(newChannel[1]),
            dataSource: series[series.indexOf(newList)],
            xValueMapper: (TelemetrySeries series, _) => series.t,
            yValueMapper: (TelemetrySeries series, _) => series.y
        ));
      });
    }
    else{
      if (channels.length == 8){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum line plot per chart reached.')));
        return;
      }
      if(newChannel[1].unit == unit){
        setState(() {
          channels.add(newChannel[1]);
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Channels in the same plot must all have the same unit.')));
      }
    }
  }
  void remove(String channelName){
    setState(() {
      // lineSeries.remove(lineSeries.firstWhere((series) => series.key.toString().replaceAll("[<'", '').replaceAll("'>]", '') == channelName));
      channels.remove(channels.firstWhere((channel) => channel.name == channelName));
    });
  }
  Color assignColor(Channel newChannel){
    return colors[channels.indexOf(newChannel)];
  }
}


