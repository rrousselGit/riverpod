import 'package:meta/meta.dart';

@internal
extension ObjectX<T> on T? {
  NewT? cast<NewT>() {
    final that = this;
    if (that is NewT) return that;
    return null;
  }

  NewT? let<NewT>(NewT? Function(T value)? cb) {
    if (cb == null) return null;
    final that = this;
    if (that != null) return cb(that);
    return null;
  }
}
