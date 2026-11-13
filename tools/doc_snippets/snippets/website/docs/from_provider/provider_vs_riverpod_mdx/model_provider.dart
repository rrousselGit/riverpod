// GENERATED from website/docs/from_provider/provider_vs_riverpod.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// The snippet that defines modelProvider, for the ones that use it.
import 'model_provider.dart';

late Ref ref;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class Counter extends ChangeNotifier {}

// Not a class, for modelProvider to have the same type in all snippets.
typedef Model = Object;

class Model1 {}

class Model2 {}

class Model3 {}

final model1Provider = Provider((ref) => Model1());
final model2Provider = Provider((ref) => Model2());
final model3Provider = Provider((ref) => Model3());

final modelProvider = Provider<Model>((ref) => Model());
