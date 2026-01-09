import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'type_checker.dart';

part 'riverpod_types/core.dart';
part 'riverpod_types/generator.dart';
part 'riverpod_types/legacy_providers.dart';
part 'riverpod_types/providers.dart';
part 'riverpod_types/widgets.dart';

/// [TypeChecker] for `Future`
const futureType = TypeChecker.fromUrl('dart:async#Future');

/// [TypeChecker] for `Stream`
const streamType = TypeChecker.fromUrl('dart:async#Stream');

/// Either `FutureOr` or `Stream`
const futureOrStreamType = TypeChecker.any([futureType, streamType]);

/// `Ref` methods that can make a provider depend on another provider.
const refBinders = {'read', 'watch', 'listen'};

/// Checks that the value is coming from a `package:flutter` package
const isFromFlutter = TypeChecker.fromPackage('flutter');
