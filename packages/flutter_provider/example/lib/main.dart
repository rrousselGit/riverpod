import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 52,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemCount: 4160,
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(5),
        addAutomaticKeepAlives: true,
        itemBuilder: (context, _) {
          return FlatButton(
            child: null,
            color: Colors.grey,
            onPressed: () {
              // open a new route
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          );
        },
      ),
    );
  }
}
