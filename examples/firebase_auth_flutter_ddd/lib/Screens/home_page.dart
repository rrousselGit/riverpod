import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: const Center(
          child: Text('Home Page'),
        ),
      ),
    );
  }
}
