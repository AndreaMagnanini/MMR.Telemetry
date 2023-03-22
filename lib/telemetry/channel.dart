class Channel{
  Channel(String channelName, String channelUnit, int channelIndex){
    name = channelName;
    unit = channelUnit;
    index = channelIndex;
  }

  late final String name;
  late final String unit;
  late final int index;
  late final List<double> values;
}