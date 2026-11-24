import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

/// Reads an object of the application the way an inspector does.
typedef ResolveObject =
    Future<Byte<ResolvedVariable>> Function(CachedObject object);

/// How many children of a value are described before omitting the rest.
const maxDescribedChildren = 100;

/// How many values a description holds before truncating the rest.
const maxDescribedValues = 1000;

/// Describes [object] as JSON, [depth] levels deep and up to [maxValues]
/// values.
///
/// Values past those are flagged as `truncated`, along with the `path` to
/// describe them on their own: the indexes of the children to go through from
/// the root, see [objectAtPath].
Future<Map<String, Object?>> describeObject(
  CachedObject object, {
  required ResolveObject resolve,
  required int depth,
  List<int> path = const [],
  int maxValues = maxDescribedValues,
}) {
  return _describe(
    object,
    resolve: resolve,
    depth: depth,
    path: path,
    budget: _Budget(maxValues),
  );
}

/// How many more values a description may read from the application.
class _Budget {
  _Budget(this.values);
  int values;
}

Future<Map<String, Object?>> _describe(
  CachedObject object, {
  required ResolveObject resolve,
  required int depth,
  required List<int> path,
  required _Budget budget,
}) async {
  // Wide and deep values would otherwise take an unbounded number of reads.
  if (budget.values <= 0) return {'truncated': true, 'path': path};
  budget.values--;

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
    return _describe(
      children[index],
      resolve: resolve,
      depth: depth - 1,
      path: [...path, index],
      budget: budget,
    );
  }

  // Children are read one at a time. Reading them all at once would send a
  // number of requests that grows exponentially with the depth.
  final described = size > maxDescribedChildren ? maxDescribedChildren : size;
  if (isMap) {
    result['entries'] = [
      for (var i = 0; i < described; i++)
        {'key': await child(i * 2), 'value': await child(i * 2 + 1)},
    ];
  } else {
    result['children'] = [
      for (var i = 0; i < described; i++)
        {'name': children[i].label ?? '$i', ...await child(i)},
    ];
  }
  if (size > described) result['omitted'] = size - described;

  return result;
}

/// Finds the object that [path] leads to, starting from [root].
///
/// [path] lists the index of the child to go through at every level. The
/// children of maps alternate between keys and values.
///
/// Throws a [FormatException] if [path] does not lead to an object, or goes
/// through one that cannot be read.
Future<CachedObject> objectAtPath(
  CachedObject root,
  List<int> path, {
  required ResolveObject resolve,
}) async {
  var object = root;
  for (final (depth, index) in path.indexed) {
    final List<CachedObject> children;
    switch (await resolve(object)) {
      case ByteVariable(:final instance):
        children = instance.children;
      case ByteError(:final error):
        throw FormatException(
          'Cannot follow path $path: the value at ${path.sublist(0, depth)} '
          'cannot be read. $error',
        );
    }
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
