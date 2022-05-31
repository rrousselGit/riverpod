import 'dart:async';

import 'package:meta/meta.dart';
import 'internals.dart';

part 'notifier/notifier.dart';
part 'notifier/notifier_family.dart';
part 'notifier/async_notifier.dart';
part 'notifier/auto_dispose_notifier.dart';
part 'notifier/auto_dispose_async_notifier.dart';

abstract class _NotifierBase<State> {
  late final ProviderElementBase<State> _element;

  // TODO should this use readSelf?
  @protected
  State get state => _element.requireState;

  @protected
  set state(State value) => _element.setState(value);
}
