import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';

class Registry extends RuleVisitorRegistry {
  final visitors = <(AbstractAnalysisRule, AstVisitor)>[];
  final afterLibraryCallbacks = <(AbstractAnalysisRule, void Function())>[];

  @override
  void addAdjacentStrings(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAnnotation(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addArgumentList(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAsExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAssertInitializer(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAssertStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAssignedVariablePattern(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addAssignmentExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addAwaitExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBinaryExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBlock(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBlockClassBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBlockFunctionBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBooleanLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addBreakStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCascadeExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCaseClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCastPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCatchClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCatchClauseParameter(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addClassDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addClassTypeAlias(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addComment(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCommentReference(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addCompilationUnit(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConditionalExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConfiguration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstantPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstructorDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstructorFieldInitializer(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstructorName(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstructorReference(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addConstructorSelector(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addContinueStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addDeclaredIdentifier(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addDeclaredVariablePattern(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addDefaultFormalParameter(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addDoStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addDotShorthandConstructorInvocation(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addDotShorthandInvocation(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addDotShorthandPropertyAccess(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addDottedName(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addDoubleLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEmptyClassBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEmptyFunctionBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEmptyStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEnumBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEnumConstantArguments(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addEnumConstantDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addEnumDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExportDirective(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExpressionFunctionBody(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addExpressionStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExtendsClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExtensionDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExtensionOnClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExtensionOverride(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addExtensionTypeDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addFieldDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFieldFormalParameter(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addForEachPartsWithDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addForEachPartsWithIdentifier(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addForEachPartsWithPattern(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addForElement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFormalParameterList(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addForPartsWithDeclarations(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addForPartsWithExpression(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addForPartsWithPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addForStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionDeclarationStatement(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionExpressionInvocation(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionReference(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionTypeAlias(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addFunctionTypedFormalParameter(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addGenericFunctionType(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addGenericTypeAlias(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addGuardedPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addHideCombinator(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addIfElement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addIfStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addImplementsClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addImplicitCallReference(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addImportDirective(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addImportPrefixReference(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addIndexExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addInstanceCreationExpression(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addIntegerLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addInterpolationExpression(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addInterpolationString(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addIsExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLabel(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLabeledStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLibraryDirective(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLibraryIdentifier(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addListLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addListPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLogicalAndPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addLogicalOrPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMapLiteralEntry(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMapPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMapPatternEntry(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMethodDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMethodInvocation(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMixinDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addMixinOnClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNamedExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNamedType(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNameWithTypeParameters(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addNativeClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNativeFunctionBody(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNullAssertPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNullAwareElement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNullCheckPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addNullLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addObjectPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addParenthesizedExpression(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addParenthesizedPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPartDirective(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPartOfDirective(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPatternAssignment(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPatternField(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPatternFieldName(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPatternVariableDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addPatternVariableDeclarationStatement(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addPostfixExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPrefixedIdentifier(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPrefixExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addPrimaryConstructorDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addPrimaryConstructorName(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addPropertyAccess(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordTypeAnnotation(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordTypeAnnotationNamedField(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordTypeAnnotationNamedFields(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRecordTypeAnnotationPositionalField(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRedirectingConstructorInvocation(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRelationalPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRepresentationConstructorName(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRepresentationDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addRestPatternElement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addRethrowExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addReturnStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addScriptTag(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSetOrMapLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addShowCombinator(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSimpleFormalParameter(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSimpleIdentifier(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSimpleStringLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSpreadElement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addStringInterpolation(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSuperConstructorInvocation(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addSuperExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSuperFormalParameter(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchCase(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchDefault(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchExpressionCase(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchPatternCase(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSwitchStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addSymbolLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addThisExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addThrowExpression(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addTopLevelVariableDeclaration(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addTryStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addTypeArgumentList(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addTypeLiteral(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addTypeParameter(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addTypeParameterList(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addVariableDeclaration(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addVariableDeclarationList(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addVariableDeclarationStatement(
    AbstractAnalysisRule rule,
    AstVisitor visitor,
  ) {
    visitors.add((rule, visitor));
  }

  @override
  void addWhenClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addWhileStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addWildcardPattern(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addWithClause(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void addYieldStatement(AbstractAnalysisRule rule, AstVisitor visitor) {
    visitors.add((rule, visitor));
  }

  @override
  void afterLibrary(AbstractAnalysisRule rule, void Function() callback) {
    afterLibraryCallbacks.add((rule, callback));
  }
}
