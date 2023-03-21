
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mmr_telemetry/shared/drawer.dart';
import 'dart:io';
import '../telemetry/telemetry.dart';

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
  Telemetry? telemetry;
  List<List<dynamic>> data = [];

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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
              ),
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
                  print("error opening or parsing file");
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Only CSV file are supported. Try opening another file.')));
                  return;
                }
                try{
                   await openFile(file).then((value) => {
                     setState((){
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opened file $value")));
                       fileName = value;
                    })});
                } on Exception catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
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
          ),],
      ),
      endDrawer: Container(
        width: MediaQuery.of(context).size.width / 5,
        margin: const EdgeInsets.only(top: 57.0),
        child: const MenuDrawer(),
      ),
    );
  }

   Future<String> openFile(PlatformFile file) async {
    print("Opening the csv file");
    var csv = File(file.path!);
    csv.readAsString().then((String csvString) => {
      setState((){
        // SOLVED PROBLEM OF LAST ITEMS IN A ROW AND FIRST ITEM OF NEXT ROW NOT CORRECTLY PARSED BECAUSE DIVIDED BY A END LINE INSTEAD OF A COLON
        csvString = csvString.replaceAll('\n', ',');
        List<List<dynamic>> parsedValues = const CsvToListConverter().convert(csvString);
        if(parsedValues.isEmpty) {
          throw Exception("CSV file correctly opened, but failed to parse into list of values");
        } else {
          data = parsedValues;
        }
      })
    });
    return file.name;
  }
}
