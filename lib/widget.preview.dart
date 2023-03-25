// Modified at: 2023-03-25 12:41:57.092
import 'package:flutter/material.dart';
import 'package:idea_widget_preview/preview.dart';



void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {

  const _PreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewApp.preview(
      paramsJson: '''{"client_id":"<no id>","initial_view_state":{"zoom":1.0,"scroll_y":0.0},"preview_id":{"value":-1},"previewed_file_path":"unspecified","theme":{"background":"#262626","text":"#d0d0d0"}}''',
      providers: () => [
        
      ],
    );
  }
}