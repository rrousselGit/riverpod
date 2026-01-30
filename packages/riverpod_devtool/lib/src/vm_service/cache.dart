part of '../vm_service.dart';

extension type CacheId(String value) {}

@immutable
class CachedObject {
  const CachedObject(this.id);

  static Future<CachedObject> create(
    String code,
    RiverpodEval eval, {
    required Disposable isAlive,
  }) async {
    final idRef = await eval.eval(
      'RiverpodDevtool.instance.cache($code)',
      isAlive: isAlive,
    );

    if (idRef.valueAsStringIsTruncated!) {
      throw StateError('CacheId value is truncated');
    }
    return CachedObject(CacheId(idRef.valueAsString!));
  }

  final CacheId id;

  Future<Instance> read(RiverpodEval eval, {required Disposable isAlive}) {
    return eval.evalInstance(
      'RiverpodDevtool.instance.getCache("$id")',
      isAlive: isAlive,
    );
  }

  Future<void> delete(RiverpodEval eval, {required Disposable isAlive}) async {
    await eval.eval(
      'RiverpodDevtool.instance.deleteCache("$id")',
      isAlive: isAlive,
    );
  }

  @override
  String toString() => 'CachedObject(id: ${id.value})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CachedObject && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
