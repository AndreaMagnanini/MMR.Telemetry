
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../telemetry/channel.dart';

class TelemetrySeries{
  TelemetrySeries(double this.t, double this.y, this.channelName);
  String channelName;
  Color? color;
  double? t;
  double? y;
}

final chartListKey = GlobalKey<ChartListState>();
final chartKey = GlobalKey<TelemetryPlotState>();

class TelemetryPlot extends StatefulWidget {
  const TelemetryPlot({Key? key}) : super(key: key);


  @override
  State<TelemetryPlot> createState() => TelemetryPlotState();
}

class TelemetryPlotState extends State<TelemetryPlot> {
  late ZoomPanBehavior  _zoomPanBehavior;
  late CrosshairBehavior _crosshairBehavior;

  double? zoomF;
  double? zoomP;

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
  void initState(){
    _zoomPanBehavior = ZoomPanBehavior(
        enableSelectionZooming: true,
        enableDoubleTapZooming: false,
        enablePanning: false,
        enableMouseWheelZooming: true,
        enablePinching: false,
        zoomMode: ZoomMode.xy
    );
    _crosshairBehavior = CrosshairBehavior(
        enable:true,
        shouldAlwaysShow: true,
        activationMode: ActivationMode.singleTap
    );
    super.initState();
  }

  void chartRefresh(double zoomP, double zoomF) {
    setState(() {
      this.zoomF = zoomF;
      this.zoomP = zoomP;
    });
  }

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
                              Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.only(top:3, bottom: 3),
                                      children: channels.map((channel) => ListTile(
                                          dense: true,
                                          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                                          leading: Container(
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(color: lineSeries[channels.indexOf(channel)].color, borderRadius: BorderRadius.circular(10))
                                          ),
                                          trailing:
                                          IconButton(onPressed: () => remove(channel.name), icon: const Icon(Icons.delete_sharp, color: Colors.white, size: 18,), padding: EdgeInsets.zero,),
                                          title: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text('${channel.name} [ ${channel.unit} ]', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 14, )
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
                        // TODO: make all 4 plots synchronized when zooming: same time axis range on zoom.
                        // TODO: automatically update displayed values if channel is inside a plot and a new csv is opened
                        // TODO: add reset zoom button.
                        child: SfCartesianChart(
                          margin: const EdgeInsets.only(bottom:10, left: 1),
                          plotAreaBorderWidth: 0,
                          primaryXAxis: NumericAxis(
                            zoomFactor: zoomF,
                            zoomPosition: zoomP,
                            name: 'primaryXAxis',
                            majorTickLines: const MajorTickLines( size: 0, width: 0 ),
                            majorGridLines: const MajorGridLines(width: 0, dashArray: [1,7]),
                            axisLine: const AxisLine(width:0),
                            labelStyle: const TextStyle(fontSize: 10),
                            tickPosition: TickPosition.inside,
                            labelPosition: ChartDataLabelPosition.inside,
                            axisBorderType: AxisBorderType.withoutTopAndBottom,
                          ),
                          primaryYAxis: NumericAxis(
                            name: 'primaryYAxis',
                            majorTickLines: const MajorTickLines( size: 0, width: 0 ),
                            majorGridLines: const MajorGridLines(width: 0.5, dashArray: [1,7]),
                            axisLine: const AxisLine(width:0),
                            labelStyle: const TextStyle(fontSize: 10),
                            tickPosition: TickPosition.inside,
                            labelPosition: ChartDataLabelPosition.inside,
                            axisBorderType: AxisBorderType.withoutTopAndBottom,
                          ),
                          zoomPanBehavior: _zoomPanBehavior,
                          crosshairBehavior: _crosshairBehavior,
                          series: lineSeries,
                          onZooming: (ZoomPanArgs args) {
                            if (args.axis?.name == 'primaryXAxis') {
                              zoomP = args.currentZoomPosition; // Storing the zoomPosition and the zoomFactor
                              zoomF = args.currentZoomFactor; // of the first chart.
                              chartListKey.currentState!.chartRefresh(zoomP, zoomF); // To refresh the second chart current State
                            }
                          },
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
        for(int i=0; i < newChannel[1].values.length; i++){
          newList.add(TelemetrySeries(newChannel[0].values[i], newChannel[1].values[i], newChannel[1].name));
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
      if(channels.contains(newChannel[1])){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selected channel is already displayed in this plot')));
        return;
      }
      setState(() {
        channels.add(newChannel[1]);
        List<TelemetrySeries> newList = [];
        for(int i=0; i < newChannel[1].values.length; i++){
          newList.add(TelemetrySeries(newChannel[0].values[i], newChannel[1].values[i], newChannel[1].name));
        }
        series.add(newList);
        lineSeries.add(FastLineSeries<TelemetrySeries, double>(
            key: ValueKey(newChannel[1].name),
            width: 0.5,
            color: assignColor(newChannel[1]),
            dataSource: series[series.indexOf(newList)],
            xValueMapper: (TelemetrySeries series, _) => series.t,
            yValueMapper: (TelemetrySeries series, _) => series.y
        ));
      });
    }
  }
  void remove(String channelName){
    setState(() {
      lineSeries.remove(lineSeries.firstWhere((series) => series.key.toString().replaceAll("[<'", '').replaceAll("'>]", '') == channelName));
      channels.remove(channels.firstWhere((channel) => channel.name == channelName));
    });
  }
  Color assignColor(Channel newChannel){
    return colors[channels.indexOf(newChannel)];
  }
}


class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 56,
        color: const Color.fromRGBO(18, 18, 18, 1),
        child: Column(
          children: [ Expanded(
              flex: MediaQuery.of(context).size.height > 1000? 80 : 85,
              child: const ChartList()
          ) ,
            Expanded(
                flex: MediaQuery.of(context).size.height > 1000? 2 : 1,
                child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 80,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blueGrey.shade900,
                    // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80),
                    child: Text('mmr-driverless  2023', style: TextStyle(fontSize: 8, color: Colors.blueGrey.shade100, fontWeight: FontWeight.normal), ) )
            )
          ],
        )
    );
  }
}

class ChartList extends StatefulWidget {
  const ChartList({Key? key}) : super(key: key);

  @override
  State<ChartList> createState() => ChartListState();
}

class ChartListState extends State<ChartList> {

  List<Widget> charts = [
     TelemetryPlot(),
     TelemetryPlot(),
     TelemetryPlot(),
     TelemetryPlot(),
  ];

  void chartRefresh(double? zoomP, double? zoomF) {
    if (zoomP != null && zoomF != null) {
      chartKey.currentState!.chartRefresh(zoomP, zoomF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 70, top: MediaQuery.of(context).size.height / 70),
        children: charts
    );
  }
}
