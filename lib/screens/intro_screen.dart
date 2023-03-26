
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import '../telemetry/channel.dart';

List<List<dynamic>> data = [];
List<Channel> channels = [];
List<Widget> menuItems = [];
List<Widget> filteredItems = [];
List<String> units = [];

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key, required this.title} );
  final String title;

  @override
  State<IntroScreen> createState() => IntroScreenState(title);
}

class IntroScreenState extends State<IntroScreen> {
  IntroScreenState(this.title);
  final String title;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        title: Row(
          children: <Widget>[
            Container(
                width: 100,
                height: 60,
                margin: const EdgeInsets.only(left:20, right:10),
                child: SvgPicture.asset('assets/mmr.svg',  color: Colors.white,)
            ),
            SizedBox(
              width: 60,
              height: 60,
              child: Image.asset('assets/coloredLogoBands.png', scale: 20,)
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                )
              ),
            )
          ]
        ),
        actions:
        <Widget>[
          Container(
            margin: const EdgeInsets.only(right:15, top:20),
            height: 60,
            child: Text(fileName?? "")
          ),
          const VerticalDivider(
            width: 1,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: Colors.white,
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            icon: const Icon(Icons.add_sharp, color: Colors.white, size: 30, ),
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            tooltip: 'Open new csv file',
            onPressed: () => openFile()
          ),
          const VerticalDivider(
            width: 5,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: Colors.white,
          ),
          Builder(
            builder: (context) => IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
              icon: const Icon(Icons.chrome_reader_mode_sharp, color: Colors.white, size: 25,),
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: "Expand Channels selector",
            ),
          ),
        ],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 5,
        margin: const EdgeInsets.only(top: 57.0),
        child:  MenuDrawer(),
      ),
    );
  }

  void openFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv']
    );
    if (result == null){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No CSV file selected.')));
      return;
    }

    final file = result.files.first;
    if (!file.name.contains("csv")){
      // ignore: use_build_context_synchronously
      print("error opening or parsing file");
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Only CSV file are supported. Try opening another file.')));
      return;
    }
    try{
      await parseFile(file).then((value) => {
        setState((){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opened file $value")));
          fileName = value;
        })
      });
    } on Exception catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<String> parseFile(PlatformFile file) async {
    print("Opening the csv file");
    var csv = File(file.path!);
    csv.readAsLines().then((List<String> lines) {

      // REMOVE HEADING FROM CSV FILE.
      List<int> indexes = [];
      for (var line in lines) {
        if (!line.startsWith('x')) { indexes.add(lines.indexOf(line)); }
        else { break; }
      }
      for (var index in indexes.reversed) { lines.removeAt(index); }

      // RECOMPOSE CLEANED FILE STRING.
      final csvString = lines.join('\n');

      setState((){
        var parsedValues = const CsvToListConverter(eol:'\n').convert(csvString);
        if(parsedValues.isEmpty) { throw Exception("CSV file correctly opened, but failed to parse into list of values"); }
        else {
          data = parsedValues;
          if(data != null){
            if(data.isNotEmpty){
              channels.clear();
            }
          }

          channels = buildChannels(data);
          if(channels!=null){
            if(channels.isNotEmpty){
              data.clear();
            }
          }

          buildMenuItems(channels);
          units = buildUnitsFilter(channels);
        }
      });
    });

    return file.name;
  }

  void buildMenuItems( List<Channel> channels ){
    menuItems.clear();
    if(channels != null){
      if(channels.isNotEmpty){
        for (Channel channel in channels) {
          menuItems.add(ListTile(
            key: Key(channel.name),
            title: Row(
              children: <Widget>[
                Text(channel.name.length > 20 ? '${channel.name.substring(0, 16)} ...' : channel.name,
                  style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
                // const VerticalDivider(
                //   width: 10,
                //   thickness: 0.5,
                //   indent: 2,
                //   endIndent: 2,
                //   color: Colors.white,
                // ),
                Container(
                  margin: const EdgeInsets.only(right:5,left:5),
                  height: 20,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '[ ${channel.unit} ]',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 15, color: Colors.tealAccent, fontWeight: FontWeight.w500, )
                  ),
                ),

              ]
            ),
            onTap: (){},
            )
          );
        }
      }
    }

    menuItems.add(emptyListDrawer);
  }

  List<String> buildUnitsFilter(List<Channel> channels){
    String value;
    for (var channel in channels){
      if(channel.unit == '') value = 'empty';
      else value = channel.unit;

      if(!units.contains(value)) units.add(value);
    }
    return units;
  }

  List<Channel> buildChannels(List<List<dynamic>> data) {
    if(data == null){ return []; }
    if(data.isEmpty){ return []; }
    if(data[0].isEmpty){ return []; }

    List<Channel> result = [];
    final RegExp regex = RegExp(r'\[(.*?)\]'); // '\[\s*(\w*)\s*\]'
    for (String channelName in data[0]){
      result.add(Channel(
        channelName.split('[')[0].replaceAll(' ', ''),
        regex.firstMatch(channelName)?[0]?.replaceAll(' ', '').replaceAll('[',  '').replaceAll(']', '') ?? "",
        data[0].indexOf(channelName))
      );
    }

    data.remove(data[0]);
    if(data[1][0] == 0.001) reduceData();
    for (List<dynamic> row in data){
      for (Channel channel in result){
        channel.values.add(row[channel.index] is int? row[channel.index].toDouble() : row[channel.index]);
      }
    }
    return result;
  }

  void reduceData(){
    List<int> indexes = [];
    for(int i = 1; i<data.length; i++){
      double value = (data[i][0]*100).toDouble();
      if(value.roundToDouble() != value) indexes.add(i);
    }
    if (indexes.isNotEmpty) {
      for (var index in indexes.reversed)
        data.removeAt(index);
    }
  }
}



final Widget emptyListDrawer = ListTile(
  title: const SizedBox(
    width:300,
    // padding: EdgeInsets.only(left:20),
    child: Text("No channel to display",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18, color: Colors.white,
        fontWeight: FontWeight.w300,
      )
    ),
  ),
  onTap: (){},
);

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => MenuDrawerState();
}

class MenuDrawerState extends State<MenuDrawer> {
  List<Widget> displayedItems = [];
  List<String> displayedUnits = [];
  String? dropdownValue;
  bool searchFilter = false;
  bool unitFilter = false;

  @override
  void initState() {
    displayedUnits.add('all');
    if(menuItems.isEmpty){ displayedItems.add(emptyListDrawer); }
    else{ displayedItems = menuItems; displayedUnits.addAll(units);}
    dropdownValue = displayedUnits.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0, left: 0.0),
                    child: const Icon(Icons.equalizer_sharp, color: Colors.white, size: 25,)
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, top: 8.0),
                    child: const Text('Plots',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400 ,
                      )
                    )
                  ),
                  Flexible(
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(left: 30, bottom: 8),
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: Colors.blueGrey.shade900),
                        onChanged: (value) => runSearchFilter(value),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5, right: 5, top:2),
                          hintText: 'filter',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(fontSize: 18,),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        )
                      ),
                    )
                  ),
                  Container(
                    height:50,
                    margin: const EdgeInsets.only(left: 15, bottom:9, top:1),
                    decoration:  BoxDecoration(
                      boxShadow: [BoxShadow(color: Colors.blueGrey.shade600, spreadRadius: 1),],
                      borderRadius: BorderRadius.circular(2.0),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      focusColor: Colors.white,
                      alignment: Alignment.centerLeft,
                      value: dropdownValue,
                      items: displayedUnits.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(' ${value}', textAlign: TextAlign.center, ));
                      }).toList(),
                      icon:  Icon(Icons.arrow_drop_down_sharp, color: Colors.blueGrey.shade900, ),
                      elevation: 0,
                      style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 16,),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      iconSize: 25,
                      borderRadius: BorderRadius.circular(5.0),
                      itemHeight: 50,
                      onChanged: (String? value) => runUnitFilter(value)
                    )
                  )
                ] ,
              )
            ),
          ),
          Expanded(
            child: ListView(
                children: displayedItems
            )
          )
        ]
      ),
    );
  }

  void resetDisplayedItems(){
    setState(() {
      if(unitFilter == false && searchFilter == false) displayedItems = menuItems;
      else {
        if(filteredItems.isNotEmpty) displayedItems = filteredItems;
      }
    });
  }

  void runSearchFilter(String enteredKeyword) {
    List<Widget> results = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        searchFilter = false;
      });
      // if the search field is empty or only contains white-space, we'll display all users
      resetDisplayedItems();
    } else {
      setState(() {
        searchFilter = true;
      });
      if(displayedItems.isNotEmpty)
        results = displayedItems.where((item) =>
          item.key.toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      else
        results = filteredItems.where((item) =>
            item.key.toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      // we use the toLowerCase() method to make it case-insensitive
      // Refresh the UI
      setState(() {
        if(displayedItems.isNotEmpty)
          filteredItems = displayedItems;
        displayedItems = results;
      });
    }
  }

  void runUnitFilter(String? enteredUnit) {
    List<Widget> results = [];
    if(enteredUnit == null){ return; }
    else if (enteredUnit.isEmpty || enteredUnit == 'all') {
      setState(() {
        dropdownValue = enteredUnit;
        unitFilter = false;
      });
      // if the search field is empty or only contains white-space, we'll display all users
      resetDisplayedItems();
    } else {
      setState(() {
        unitFilter = true;
      });
      if(displayedItems.isNotEmpty)
        results = displayedItems.where((item) => checkUnits(item, enteredUnit)).toList();
      else
        results = filteredItems.where((item) => checkUnits(item, enteredUnit)).toList();
      // we use the toLowerCase() method to make it case-insensitive
      // Refresh the UI
      setState(() {
        dropdownValue = enteredUnit;
        if(displayedItems.isNotEmpty)
          filteredItems = displayedItems;
        displayedItems = results;
      });
    }
  }

  bool checkUnits(Widget item, String unit){
    var name = item.key.toString().replaceAll("[<'", '').replaceAll("'>]", '');
    var channel = channels.where((element) => element.name == name).toList();
    String value = '';
    if(channel.isEmpty){
      print('name ${name} from widget ${item.toString()} didn\'t have a corresponding channel');
      return false;
    }
    else{
      if(unit != 'empty') value = unit;
      return channel[0].unit == value;
    }
  }
}


