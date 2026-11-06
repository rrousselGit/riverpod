import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../how_to/cancel/detail_screen/codegen.dart';
import 'usage/codegen.dart';

/* SNIPPET START */
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // highlight-next-line
        currentItemIdProvider.overrideWithValue('123'),
      ],
      // The detail page will rely on '123' as the current item ID, without
      // having to pass it explicitly.
      child: const DetailPageView(),
    );
  }
}
