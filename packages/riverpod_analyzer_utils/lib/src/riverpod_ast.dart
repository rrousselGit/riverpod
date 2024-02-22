library riverpod_ast;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

import '../riverpod_analyzer_utils.dart';
import 'argument_list_utils.dart';

part 'riverpod_ast/provider_or_family_expression.dart';
part 'riverpod_ast/provider_declaration.dart';
part 'riverpod_ast/provider_listenable_expression.dart';
part 'riverpod_ast/ref_invocation.dart';
part 'riverpod_ast/widget_ref_invocation.dart';

extension ExpressionX on Expression {
  ProviderListenableExpression? get providerListenable {
    return upsert('ProviderListenableExpression', () {
      return ProviderListenableExpression._parse(this);
    });
  }
}

extension MethodInvocationX on MethodInvocation {
  RefInvocation? get refInvocation {
    return upsert('RefInvocation', () => RefInvocation._parse(this));
  }

  WidgetRefInvocation? get widgetRefInvocation {
    return upsert(
      'WidgetRefInvocation',
      () => WidgetRefInvocation._parse(this),
    );
  }
}

extension on AstNode {
  R upsert<R>(
    String key,
    R Function() create,
  ) {
    // Using a record to differentiate "null value" from "no value".
    final existing = getProperty<(R value,)>('riverpod.$key');
    if (existing != null) return existing.$1;

    final created = create();
    setProperty(key, (created,));
    return created;
  }
}

extension<T> on T? {
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
