import 'package:devtools_app_shared/src/utils/globals.dart';
import 'package:devtools_app_shared/ui.dart' as shared_ui;
import 'package:flutter/material.dart';

void initializeDevToolsTheme() {
  setGlobal(shared_ui.IdeTheme, shared_ui.IdeTheme());
}

Widget testApp(Widget child) {
  initializeDevToolsTheme();

  return MaterialApp(home: Scaffold(body: child));
}
