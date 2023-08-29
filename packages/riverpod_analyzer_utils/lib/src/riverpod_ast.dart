import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../riverpod_analyzer_utils.dart';
import 'argument_list_utils.dart';
import 'errors.dart';

part 'riverpod_ast/consumer.dart';
part 'riverpod_ast/generator_provider_declaration.dart';
part 'riverpod_ast/legacy_provider_declaration.dart';
part 'riverpod_ast/provider_container_instance_creation_expression.dart';
part 'riverpod_ast/provider_declaration.dart';
part 'riverpod_ast/provider_listenable_expression.dart';
part 'riverpod_ast/ref_invocation.dart';
part 'riverpod_ast/resolve_riverpod.dart';
part 'riverpod_ast/riverpod_annotation.dart';
part 'riverpod_ast/visitor.dart';
part 'riverpod_ast/widget_ref_invocation.dart';
part 'riverpod_ast/provider_scope.dart';
part 'riverpod_ast/provider_override.dart';

@sealed
abstract class RiverpodAst {
  RiverpodAst? _parent;
  RiverpodAst? get parent => _parent;

  void accept(RiverpodAstVisitor visitor);

  @mustCallSuper
  void visitChildren(RiverpodAstVisitor visitor);
}

@internal
extension ObjectUtils<T> on T? {
  R? cast<R>() {
    final that = this;
    if (that is R) return that;
    return null;
  }

  R? let<R>(R? Function(T value)? cb) {
    if (cb == null) return null;
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}
