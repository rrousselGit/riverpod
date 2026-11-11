import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

/// Reads an object of the application the way an inspector does.
typedef ResolveObject =
    Future<Byte<ResolvedVariable>> Function(CachedObject object);

/// How many children of a value are described before omitting the rest.
const maxDescribedChildren = 100;

/// Describes [object] as JSON, [depth] levels deep.
///
/// Values nested deeper are flagged as `truncated`, along with the `path` to
/// describe them on their own: the indexes of the children to go through from
/// the root, see [objectAtPath].
Future<Map<String, Object?>> describeObject(
  CachedObject object, {
  required ResolveObject resolve,
  required int depth,
  List<int> path = const [],
}) async {
  final ResolvedVariable variable;
  switch (await resolve(object)) {
    case ByteError(:final error):
      return {'error': '$error'};
    case ByteVariable(:final instance):
      variable = instance;
  }

  final type = switch (variable) {
    NullVariable() => 'Null',
    BoolVariable() => 'bool',
    IntVariable() => 'int',
    DoubleVariable() => 'double',
    StringVariable() => 'String',
    TypeVariable() => 'Type',
    RecordVariable() => 'Record',
    ListVariable() => 'List',
    SetVariable() => 'Set',
    MapVariable() => 'Map',
    AsyncValueVariable(:final type) ||
    UnknownObjectVariable(:final type) => type,
  };

  switch (variable) {
    case NullVariable():
      return {'type': type, 'value': null};
    case BoolVariable(:final Object value) ||
        IntVariable(:final Object value) ||
        StringVariable(:final Object value) ||
        TypeVariable(name: final Object value):
      return {'type': type, 'value': value};
    case DoubleVariable(:final value):
      // JSON cannot represent NaN and infinity.
      return {'type': type, 'value': value.isFinite ? value : '$value'};
    case RecordVariable() ||
        ListVariable() ||
        SetVariable() ||
        MapVariable() ||
        AsyncValueVariable() ||
        UnknownObjectVariable():
      break;
  }

  final children = variable.children;
  final isMap = variable is MapVariable;
  final size = isMap ? children.length ~/ 2 : children.length;
  final result = <String, Object?>{
    'type': type,
    if (variable case UnknownObjectVariable(:final identityHashCode?))
      'hash': identityHashCode.toRadixString(16),
    if (variable is! AsyncValueVariable && variable is! UnknownObjectVariable)
      'size': size,
  };
  if (children.isEmpty) return result;
  if (depth <= 0) return {...result, 'truncated': true, 'path': path};

  Future<Map<String, Object?>> child(int index) {
    return describeObject(
      children[index],
      resolve: resolve,
      depth: depth - 1,
      path: [...path, index],
    );
  }

  final described = size > maxDescribedChildren ? maxDescribedChildren : size;
  if (isMap) {
    result['entries'] = await Future.wait([
      for (var i = 0; i < described; i++)
        (
          child(i * 2),
          child(i * 2 + 1),
        ).wait.then((entry) => {'key': entry.$1, 'value': entry.$2}),
    ]);
  } else {
    result['children'] = await Future.wait([
      for (var i = 0; i < described; i++)
        child(i).then((value) => {'name': children[i].label ?? '$i', ...value}),
    ]);
  }
  if (size > described) result['omitted'] = size - described;

  return result;
}

/// Finds the object that [path] leads to, starting from [root].
///
/// [path] lists the index of the child to go through at every level. The
/// children of maps alternate between keys and values.
///
/// Throws a [FormatException] if [path] does not lead to an object.
Future<CachedObject> objectAtPath(
  CachedObject root,
  List<int> path, {
  required ResolveObject resolve,
}) async {
  var object = root;
  for (final (depth, index) in path.indexed) {
    final children = switch (await resolve(object)) {
      ByteVariable(:final instance) => instance.children,
      ByteError() => const <CachedObject>[],
    };
    if (index < 0 || index >= children.length) {
      throw FormatException(
        'Invalid path $path: no child at index $index of '
        '${path.sublist(0, depth)}, which has ${children.length} children.',
      );
    }
    object = children[index];
  }
  return object;
}
