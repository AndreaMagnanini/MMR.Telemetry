// Modified at: 2023-03-18 20:08:29.891
import 'package:flutter/material.dart';
import 'package:idea_widget_preview/preview.dart';
import '../main.dart';


void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {

  const _PreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewApp.preview(
      paramsJson: '''{"client_id":"mmr_telemetry___2540bd0a618f01acdf261a84f2ff3c1885a697fd2ab855fe8ee07af0b573840e","initial_view_state":{"zoom":1.0,"scroll_y":0.0},"preview_id":{"value":1},"previewed_file_path":"../main.dart","theme":{"background":"#1e1f22","text":"#a9b7c6"},"kotlin_server_port":43685}''',
      providers: () => [
                AppPreview(),

      ],
    );
  }
}