import 'package:flutter/material.dart';
import 'package:idea_widget_preview/preview.dart';
import 'package:mmr_telemetry/screens/intro_screen.dart';

// TODO: save application state on close to keep same values on restart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: "root",
      title: 'MMR-Telemetry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary:  Colors.blueGrey.shade900,
          secondary: Colors.blueGrey.shade600,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.purple, fontFamily: 'Ubuntu')),
      ),
      home: const IntroScreen(title: 'MMR - Telemetry'),
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
        return const MyApp();
      }
    )
  ];
}
