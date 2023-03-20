import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.blueGrey.shade900,
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context){
    final List<String> menuTitles = [
      'Home',
      'Play'
    ];

    List<Widget> menuItems = [];
    menuItems.add( SizedBox(
        height: 64.0,
        child: DrawerHeader(
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Row(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 10.0, left: 0.0),
                child: const Icon(Icons.equalizer_sharp, color: Colors.white, size: 25,)),
            Container(
              margin: const EdgeInsets.only(left: 10.0, bottom: 5.0),
              child: const Text('Plots',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400 ,)))
          ] ,
        ))));
    for (String element in menuTitles) {
      menuItems.add(ListTile(
        title: Text(element,
          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300)),
        onTap: (){},
      ));
    }
    return menuItems;
  }
}
