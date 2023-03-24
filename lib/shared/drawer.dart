import 'package:flutter/material.dart';
import 'package:mmr_telemetry/telemetry/channel.dart';
import 'package:mmr_telemetry/telemetry/telemetry.dart';

// class MenuDrawer extends StatefulWidget {
//   MenuDrawer({super.key, required this.data});
//   List<List<dynamic>> data;
//
//   @override
//   State<MenuDrawer> createState() => MenuDrawerState(data);
// }
//
// class MenuDrawerState extends State<MenuDrawer> {
//   MenuDrawerState(this.data);
//   List<List<dynamic>> data;
//
//   @override
//   Widget build(BuildContext context) {
//     List<Channel> channels = [];
//     if(data.isNotEmpty) { channels = buildChannels(data); }
//
//     return Drawer(
//       elevation: 0,
//       backgroundColor: Colors.blueGrey.shade900,
//       child: ListView(
//         children: buildMenuItems(context, channels),
//       ),
//     );
//   }
//
//   Telemetry? telemetry;
//   List<Widget> buildMenuItems(BuildContext context, List<Channel> channels){
//
//     List<Widget> menuItems = [];
//     menuItems.add( SizedBox(
//         height: 64.0,
//         child: DrawerHeader(
//             decoration: const BoxDecoration(color: Colors.blueGrey),
//             child: Row(
//               children: <Widget>[
//                 Container(
//                     margin: const EdgeInsets.only(bottom: 10.0, left: 0.0),
//                     child: const Icon(Icons.equalizer_sharp, color: Colors.white, size: 25,)),
//                 Container(
//                     margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
//                     child: const Text('Plots',
//                         style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400 ,)))
//               ] ,
//             ))));
//     if(channels.isNotEmpty){
//       for (Channel channel in channels) {
//         menuItems.add(ListTile(
//           title: Text(channel.name,
//               style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300)),
//           onTap: (){},
//         ));
//       }
//     }
//     else{
//       menuItems.add(ListTile(
//           title: const Text("No channel to display",
//           style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300)),
//           onTap: (){},
//       ));
//     }
//
//     return menuItems;
//   }
//
//   buildChannels(List<List> data) {
//     if(data[0].isEmpty){ return null; }
//
//     List<Channel> result = [];
//     final RegExp regex = RegExp("\[\s*(\w*)\s*\]");
//     for (String channelName in data[0]){
//       result.add(Channel(
//           channelName.split(' ')[0],
//           regex.firstMatch(channelName).toString(),
//           data[0].indexOf(channelName)
//         )
//       );
//     }
//   }
// }
