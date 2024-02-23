library nodes;

import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'analyzer_utils.dart';
import 'argument_list_utils.dart';
import 'element_util.dart';
import 'object_extensions.dart';

part 'nodes/widgets/stateless_widget.dart';
part 'nodes/widgets/stateful_widget.dart';
part 'nodes/widgets/widget.dart';

part 'nodes/dependencies.dart';
part 'nodes/providers/function.dart';
part 'nodes/providers/legacy.dart';
part 'nodes/providers/notifier.dart';
part 'nodes/providers/providers.dart';
part 'nodes/providers/identifiers.dart';

part 'nodes/provider_for.dart';
part 'nodes/provider_or_family.dart';
part 'nodes/riverpod.dart';
part 'nodes/provider_listenable.dart';
part 'nodes/ref_invocation.dart';
part 'nodes/widget_ref_invocation.dart';

part 'nodes/scopes/overrides.dart';
part 'nodes/scopes/provider_container.dart';
part 'nodes/scopes/provider_scope.dart';

part 'nodes.g.dart';

const _ast = Object();

extension RawTypeX on DartType {
  /// Returns whether this type is a `Raw` typedef from `package:riverpod_annotation`.
  bool get isRaw {
    final alias = this.alias;
    if (alias == null) return false;
    return alias.element.name == 'Raw' &&
        isFromRiverpodAnnotation.isExactly(alias.element);
  }
}

class _Cache<R> {
  final _cacheExpando = Expando<(Object?,)>();

  R call(Object e, R Function() create) {
    final existing = _cacheExpando[e];
    if (existing != null) return existing.$1 as R;

    final created = create();
    _cacheExpando[e] = (created,);
    return created;
  }
}
