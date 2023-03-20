import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmr_telemetry/shared/drawer.dart';
import 'package:open_file/open_file.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.title} );
  final String title;

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
                  margin: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    'assets/mmr.svg', color: Colors.white,)),
              SizedBox(
                  width: 30,
                  height: 60,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 60, color: Colors.blue.shade800,)),
              SizedBox(
                  width: 30,
                  height: 60,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 60, color: Colors.green.shade500,)),
              SizedBox(
                  width: 30,
                  height: 60,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 60, color: Colors.orange.shade600,)),
              Container(
                margin: const EdgeInsets.all(40),
                child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      // shadows: [
                      //   Shadow(
                      //     offset: Offset(1.0, 1.0),
                      //     color: Colors.white
                      //   )
                      // ]
                    )),
              )
            ]),
        actions:
        <Widget>[
          const VerticalDivider(
            width: 1,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: Colors.white,
          ),
          IconButton(

              icon: const Icon(Icons.add_sharp, color: Colors.white, size: 30, ),
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              tooltip: 'Open new csv file',
              onPressed: () async {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Only CSV file are supported. Try opening another file.')));
                  return;
                }
                openFile(file);
              }
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
              icon: const Icon(Icons.chrome_reader_mode_sharp, color: Colors.white, size: 25,),
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: "Expand Channels selector",
            ),
          ),],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 5,
        margin: const EdgeInsets.only(top: 57.0),
        child: const MenuDrawer(),
      ),
      );
  }

  void openFile(PlatformFile file){
    OpenFile.open(file.path!);
  }
}
