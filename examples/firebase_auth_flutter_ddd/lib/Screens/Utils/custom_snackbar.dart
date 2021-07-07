import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildCustomSnackBar({
  required BuildContext context,
  required Color flashBackground,
  required Text content,
  required IconData icon,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: flashBackground,
      padding: const EdgeInsets.all(5),
      content: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
    children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(width: 20,),
        content
    ],
  ),
      )));
}
