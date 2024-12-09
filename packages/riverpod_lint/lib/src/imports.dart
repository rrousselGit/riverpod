import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';
import 'package:meta/meta.dart';

extension ImportFix on DartFileEditBuilder {
  // riverpod
  @useResult
  String importRef() => _importRiverpod('Ref');

  // flutter_riverpod
  @useResult
  String importWidgetRef() => _importFlutterRiverpod('WidgetRef');
  @useResult
  String importConsumerStatefulWidget() =>
      _importFlutterRiverpod('ConsumerStatefulWidget');
  @useResult
  String importConsumerWidget() => _importFlutterRiverpod('ConsumerWidget');
  @useResult
  String importConsumerState() => _importFlutterRiverpod('ConsumerState');
  @useResult
  String importConsumer() => _importFlutterRiverpod('Consumer');
  @useResult
  String importProviderScope() => _importFlutterRiverpod('ProviderScope');

  // flutter_hooks
  @useResult
  String importHookWidget() => _importFlutterHooks('HookWidget');

// hooks_riverpod
  @useResult
  String importHookConsumerWidget() =>
      _importHooksRiverpod('HookConsumerWidget');
  @useResult
  String importStatefulHookConsumerWidget() =>
      _importHooksRiverpod('StatefulHookConsumerWidget');

  // riverpod_annotation
  @useResult
  String importDependenciesClass() => _importRiverpodAnnotation('Dependencies');
  @useResult
  String importRiverpod() => _importRiverpodAnnotation('riverpod');
  @useResult
  String importRiverpodClass() => _importRiverpodAnnotation('Riverpod');

  // Flutter widgets:
  @useResult
  String importState() => _importFlutterWidgets('State');
  @useResult
  String importStatelessWidget() => _importFlutterWidgets('StatelessWidget');
  @useResult
  String importStatefulHookWidget() =>
      _importFlutterWidgets('StatefulHookWidget');
  @useResult
  String importStatefulWidget() => _importFlutterWidgets('StatefulWidget');

  @useResult
  String _importWithPrefix(String name, List<Uri> uris) {
    for (var i = 0; i < uris.length - 1; i++) {
      final uri = uris[i];
      if (importsLibrary(uri)) return _buildImport(uri, name);
    }

    final lastUri = uris.last;
    return _buildImport(lastUri, name);
  }

  @useResult
  String _importRiverpod(String name) {
    return _importWithPrefix(name, [
      Uri(scheme: 'package', path: 'hooks_riverpod/hooks_riverpod.dart'),
      Uri(scheme: 'package', path: 'flutter_riverpod/flutter_riverpod.dart'),
      Uri(scheme: 'package', path: 'riverpod/riverpod.dart'),
    ]);
  }

  @useResult
  String _importHooksRiverpod(String name) {
    return _importWithPrefix(name, [
      Uri(scheme: 'package', path: 'hooks_riverpod/hooks_riverpod.dart'),
    ]);
  }

  @useResult
  String _importFlutterRiverpod(String name) {
    return _importWithPrefix(name, [
      Uri(scheme: 'package', path: 'hooks_riverpod/hooks_riverpod.dart'),
      Uri(scheme: 'package', path: 'flutter_riverpod/flutter_riverpod.dart'),
    ]);
  }

  @useResult
  String _importRiverpodAnnotation(String name) {
    return _importWithPrefix(name, [
      Uri(
        scheme: 'package',
        path: 'riverpod_annotation/riverpod_annotation.dart',
      ),
    ]);
  }

  @useResult
  String _importFlutterHooks(String name) {
    return _importWithPrefix(name, [
      Uri(scheme: 'package', path: 'flutter_hooks/flutter_hooks.dart'),
    ]);
  }

  @useResult
  String _importFlutterWidgets(String name) {
    return _importWithPrefix(name, [
      Uri(scheme: 'package', path: 'flutter/cupertino.dart'),
      Uri(scheme: 'package', path: 'flutter/material.dart'),
      Uri(scheme: 'package', path: 'flutter/widgets.dart'),
    ]);
  }

  String _buildImport(Uri uri, String name) {
    final import = importLibraryElement(uri);

    final prefix = import.prefix;
    if (prefix != null) return '$prefix.$name';

    return name;
  }
}
