import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

class PreferKeepAliveAnnotation extends AnalysisRule {
  PreferKeepAliveAnnotation()
    : super(name: code.name, description: code.problemMessage);

  static const code = LintCode(
    'prefer_keep_alive_annotation',
    'Providers that start by calling `ref.keepAlive()` are always kept alive.',
    correctionMessage:
        'Remove `ref.keepAlive()` and annotate the provider '
        'with `@Riverpod(keepAlive: true)`.',
    severity: DiagnosticSeverity.WARNING,
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (!_isRefKeepAlive(node)) return;

    // Only a "fire and forget" `ref.keepAlive();` is equivalent to the
    // annotation. Keeping the `KeepAliveLink` around means the provider is
    // expected to be disposed at some point.
    final statement = node.parent;
    if (statement is! ExpressionStatement) return;

    final block = statement.parent;
    if (block is! Block) return;
    // Anywhere but the first statement, the call may not be reached, be it
    // because of an early return or of an exception.
    if (block.statements.firstOrNull != statement) return;

    // The block must be the body of the provider itself. A block nested inside
    // an `if`/`try`/closure is a conditional `keepAlive`, which the annotation
    // cannot express.
    final body = block.parent;
    if (body is! BlockFunctionBody) return;

    final provider = _providerCreatedBy(body);
    if (provider == null) return;

    // The provider is already annotated with `@Riverpod(keepAlive: true)`.
    // The `ref.keepAlive()` is redundant, but this rule is not about
    // redundancy.
    if (!provider.providerElement.isAutoDispose) return;

    rule.reportAtNode(node);
  }

  /// Whether [node] is an invocation of `Ref.keepAlive`.
  bool _isRefKeepAlive(MethodInvocation node) {
    final methodName = node.methodName;
    if (methodName.name != 'keepAlive') return false;

    final targetType = node.realTarget?.staticType;
    if (targetType == null || !isRiverpodRef(targetType)) return false;

    final method = methodName.element;
    if (method is! MethodElement) return false;

    final owner = method.enclosingElement;
    if (owner == null) return false;

    // Since Ref is sealed, checking that the function is from the
    // package:riverpod before checking its type skips iterating over the
    // superclasses of an element if it's not from Riverpod.
    return isFromRiverpod.isExactly(owner) && refType.isAssignableFrom(owner);
  }

  /// The generated provider for which [body] is the "create" function,
  /// or `null` if [body] is anything else.
  GeneratorProviderDeclaration? _providerCreatedBy(BlockFunctionBody body) {
    switch (body.parent) {
      // @riverpod
      // int fn(Ref ref) { ... }
      case FunctionExpression(parent: final FunctionDeclaration declaration):
        return declaration.provider;

      // @riverpod
      // class Example extends _$Example {
      //   int build() { ... }
      // }
      case final MethodDeclaration method:
        final declaration = method.thisOrAncestorOfType<ClassDeclaration>();
        if (declaration == null) return null;

        final provider = declaration.provider;
        // Other methods of a notifier are not the "create" function. Calling
        // `keepAlive` there is a deliberate runtime decision.
        if (provider?.buildMethod != method) return null;

        return provider;

      case _:
        return null;
    }
  }
}
