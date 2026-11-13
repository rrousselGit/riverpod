// GENERATED from website/docs/root/do_dont.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';

late WidgetRef ref;
late BuildContext context;

class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => throw UnimplementedError();
}

class Model {
  void init() {}
}

final myProvider = Provider((ref) => Model());

class MyForm {
  Map<String, String> toJson() => {};
}

final formStateProvider = Provider((ref) => MyForm());

class WidgetState extends ConsumerState<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Bad: the provider should initialize itself
    ref.read(myProvider).init();
  }

  @override
  Widget build(BuildContext context) => const Placeholder();
}
