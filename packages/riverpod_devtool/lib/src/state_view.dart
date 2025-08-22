import 'package:flutter/widgets.dart';

import 'ui.dart';

class StateView extends StatelessWidget {
  const StateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Panel(header: Text('State view'), child: Text('Hello'));
  }
}
