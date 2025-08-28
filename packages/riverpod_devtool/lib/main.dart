import 'package:devtools_app_shared/ui.dart' as devtools_shared_ui;
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/provider_list.dart';
import 'src/state_view.dart';

void main() {
  runApp(const ProviderScope(child: RiverpodDevtoolExtension()));
}

class RiverpodDevtoolExtension extends ConsumerWidget {
  const RiverpodDevtoolExtension({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: DevToolsExtension(child: _FlexibleLayout()),
    );
  }
}

class _FlexibleLayout extends StatelessWidget {
  const _FlexibleLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(child: ProviderListView());
    // return devtools_shared_ui.SplitPane(
    //   axis: Axis.horizontal,
    //   initialFractions: const [0.3, 0.7],
    //   minSizes: const [50.0, 100.0],
    //   children: const [ProviderListView(), StateView()],
    // );
  }
}
