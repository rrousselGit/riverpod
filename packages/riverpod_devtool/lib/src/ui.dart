import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:flutter/widgets.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, this.header, required this.child});

  final Widget? header;
  final Widget child;

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

    return devtools_shared_ui.RoundedOutlinedBorder(child: content);
  }
}
