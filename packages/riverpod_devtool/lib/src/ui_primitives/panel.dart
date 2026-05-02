import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    this.header,
    required this.child,
    this.roundedBorders = const (
      bottomLeft: true,
      bottomRight: true,
      topLeft: true,
      topRight: true,
    ),
    this.clip = true,
  });

  final Widget? header;
  final Widget child;
  final ({bool bottomLeft, bool bottomRight, bool topLeft, bool topRight})
  roundedBorders;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    var content = child;
    if (header case final header?) {
      content = Column(
        children: [
          devtools_shared_ui.AreaPaneHeader(
            roundedTopBorder: false,
            includeTopBorder: false,
            title: header,
          ),
          Expanded(child: content),
        ],
      );
    }

    return devtools_shared_ui.RoundedOutlinedBorder(
      clip: clip,
      showBottomLeft: roundedBorders.bottomLeft,
      showBottomRight: roundedBorders.bottomRight,
      showTopLeft: roundedBorders.topLeft,
      showTopRight: roundedBorders.topRight,
      child: Material(child: content),
    );
  }
}
