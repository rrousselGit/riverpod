// ignore: unnecessary_library_name, used by the generator
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
import 'package:analyzer/dart/element/type_provider.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'analyzer_utils.dart';
import 'argument_list_utils.dart';
import 'object_extensions.dart';

part 'nodes/widgets/state.dart';
part 'nodes/widgets/stateful_widget.dart';
part 'nodes/widgets/stateless_widget.dart';
part 'nodes/widgets/widget.dart';

part 'nodes/dependencies.dart';
part 'nodes/generated_providers/function.dart';
part 'nodes/manual_providers/provider.dart';
part 'nodes/generated_providers/notifier.dart';
part 'nodes/generated_providers/providers.dart';
part 'nodes/generated_providers/identifiers.dart';

part 'nodes/provider_for.dart';
part 'nodes/provider_or_family.dart';
part 'nodes/annotation.dart';
part 'nodes/provider_listenable.dart';
part 'nodes/ref_invocation.dart';
part 'nodes/widget_ref_invocation.dart';

part 'nodes/scopes/overrides.dart';
part 'nodes/scopes/provider_container.dart';
part 'nodes/scopes/provider_scope.dart';

part 'nodes.g.dart';

const _ast = Object();

extension AstX on AstNode {
  Iterable<AstNode> get ancestors sync* {
    var parent = this.parent;
    while (parent != null) {
      yield parent;
      parent = parent.parent;
    }
  }
}

extension RawTypeX on DartType {
  /// Returns whether this type is a `Raw` typedef from `package:riverpod_annotation`.
  bool get isRaw {
    final alias = this.alias;
    if (alias == null) return false;
    return alias.element.name == 'Raw' &&
        isFromRiverpodAnnotation.isExactly(alias.element);
  }
}

class _Cache<CachedT> {
  final _cacheExpando = Expando<(Object?,)>();

  CachedT call(Object e, CachedT Function() create) {
    final existing = _cacheExpando[e];
    if (existing != null) return existing.$1 as CachedT;

    final created = create();
    _cacheExpando[e] = (created,);
    return created;
  }
}
