// GENERATED from website/docs/concepts2/providers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class User {
  User();
  factory User.fromJson(Object? json) => User();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

final helloWorldProvider = Provider<String>((ref) => 'Hello world!');

// _state is internally modifiable
// but cannot be modified externally
var _state = 0;
int get state => _state;
