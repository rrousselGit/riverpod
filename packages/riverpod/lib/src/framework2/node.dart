part of 'framework.dart';

@internal
@immutable
abstract class DebugDependentSource {
  @mustBeOverridden
  @override
  bool operator ==(Object other);

  @mustBeOverridden
  @override
  int get hashCode;
}

@internal
class Node<StateT> {
  Node({
    required this.owner,
    required this.element,
  });

  final ProviderContainer owner;
  final ProviderElement<StateT> element;

  final _debugDependentSources = <DebugDependentSource>[];
  final _listeners = <ProviderListener<StateT>>[];
}
