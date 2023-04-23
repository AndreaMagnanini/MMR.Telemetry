import 'dart:ui';

class TelemetrySeries{
  TelemetrySeries(double this.t, double this.y, this.channelName);
  String channelName;
  Color? color;
  double? t;
  double? y;
}