// GENERATED from packages/riverpod_annotation/lib/experimental/scope.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/experimental/scope.dart';

// The snippet that defines BookView, for the ones that use it.
import 'book_view.dart';

final selectedBookIDProvider = Provider<String>(selectedBookID);

@Riverpod(dependencies: [])
String selectedBookID(Ref ref) => throw UnimplementedError();

@Dependencies([selectedBookID])
class BookView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBookID = ref.watch(selectedBookIDProvider);
    return Text(selectedBookID);
  }
}
