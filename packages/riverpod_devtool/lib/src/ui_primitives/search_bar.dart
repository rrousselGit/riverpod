import 'package:flutter/material.dart';

class DevtoolSearchBar extends StatelessWidget {
  const DevtoolSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}
