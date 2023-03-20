import 'package:flutter/material.dart';
import 'package:idea_widget_preview/preview.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMR-Telemetry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary:  Colors.blueGrey.shade900,
          secondary: Colors.blueGrey.shade600,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple)),
      ),
      home: const MyHomePage(title: 'MMR - Telemetry'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              child: Text(widget.title, textScaleFactor: 1.5,),
            )
        ]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Open new csv file',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add action to perform file selection from file system')));
            }
          )],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AppPreview extends PreviewProvider {
  @override
  List<Preview> get previews => [
    // 3) Individual declarations
    Preview(
      title: "AppPreview",
      builder: (BuildContext context) {
        return MyApp();
      }
    )
  ];
}
