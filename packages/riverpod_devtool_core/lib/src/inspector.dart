import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';
import 'package:vm_service/vm_service.dart';

import 'package_name_provider.dart';
import 'vm_service.dart';

class InspectorSettings {
  const InspectorSettings({this.showExternalPrivateMembers = false});

  final bool showExternalPrivateMembers;

  InspectorSettings copyWith({bool? showExternalPrivateMembers}) {
    return InspectorSettings(
      showExternalPrivateMembers:
          showExternalPrivateMembers ?? this.showExternalPrivateMembers,
    );
  }
}

final inspectorSettingsProvider =
    NotifierProvider<InspectorSettingsNotifier, InspectorSettings>(
      InspectorSettingsNotifier.new,
    );

class InspectorSettingsNotifier extends Notifier<InspectorSettings> {
  @override
  InspectorSettings build() => const InspectorSettings();

  void setShowExternalPrivateMembers({required bool value}) {
    state = state.copyWith(showExternalPrivateMembers: value);
  }
}

/// Reads [CachedObject]s as values that an inspector can render.
final resolvedVariableForObjectProvider = FutureProvider.autoDispose
    .family<Byte<ResolvedVariable>, CachedObject>(
      name: 'resolvedVariableForObjectProvider',
      (ref, object) async {
        ref.watch(devtoolSessionProvider);
        final eval = await ref.watch(evalProvider.future);

        final byte = await object.read(eval, isAlive: ref.disposable());

        switch (byte) {
          case ByteError():
            return ByteError(byte.error);
          case ByteVariable():
            var instance = ResolvedVariable.fromInstance(object, byte.instance);

            if (instance == null) {
              final classId = byte.instance.classRef?.classId;
              switch (byte.instance.classRef) {
                // AsyncValue:
                case ClassRef(library: final lib?, name: 'AsyncValue') ||
                        ClassRef(library: final lib?, name: 'AsyncData') ||
                        ClassRef(library: final lib?, name: 'AsyncError') ||
                        ClassRef(library: final lib?, name: 'AsyncLoading')
                    when lib.uri!.startsWith('package:riverpod/'):
                  final isAlive = ref.disposable();
                  final metadata = await eval.riverpodFramework.evalInstance(
                    isAlive: isAlive,
                    scope: {'that': byte.instance.id!},
                    '['
                    'that.hasValue, '
                    'that.hasError, '
                    'that.isLoading, '
                    'that.isRefreshing, '
                    'that.isReloading, '
                    'that.progress, '
                    ']',
                  );
                  if (metadata case ByteError()) {
                    return ByteError(metadata.error);
                  }
                  metadata as ByteVariable<VmInstance>;

                  final bytes = metadata.instance.elements!
                      .map(Byte.instanceRefOrNull)
                      .toList();
                  if (bytes.whereType<ByteError<Object>>().firstOrNull
                      case final firstError?) {
                    return ByteError(firstError.error);
                  }

                  final [
                    hasValue,
                    hasError,
                    isLoading,
                    isRefreshing,
                    isReloading,
                  ] = bytes
                      .take(5)
                      .map(
                        (e) => e!.require.instance.raw.valueAsString == 'true',
                      )
                      .toList();

                  final progressRef = bytes[5]?.require.instance;
                  final progress = switch (progressRef?.kind) {
                    null || InstanceKind.kNull => null,
                    _ => double.tryParse(progressRef!.valueAsString!),
                  };

                  instance = AsyncValueVariable(
                    object,
                    byte.instance,
                    Uri.parse('package:riverpod/src/framework.dart'),
                    hasValue: hasValue,
                    hasError: hasError,
                    progress: progress,
                    loadingStatus: switch (null) {
                      _ when isRefreshing => AsyncLoadingStatus.refreshing,
                      _ when isReloading => AsyncLoadingStatus.reloading,
                      _ when isLoading => AsyncLoadingStatus.other,
                      _ => null,
                    },
                  );

                case _:
                  final getters = classId != null
                      ? await ref.watch(gettersForClassProvider(classId).future)
                      : const <({String name, Uri uri})>{};

                  final showExternalPrivateMembers = ref.watch(
                    inspectorSettingsProvider.select(
                      (s) => s.showExternalPrivateMembers,
                    ),
                  );
                  final currentPackageName = await ref.watch(
                    currentPackageNameProvider.future,
                  );

                  instance = UnknownObjectVariable(
                    object,
                    byte.instance,
                    children: UnknownObjectVariable.computeChildren(
                      object,
                      getters,
                      byte.instance.fields ?? const [],
                      showExternalPrivateMembers: showExternalPrivateMembers,
                      currentPackageName: currentPackageName,
                    ),
                  );
              }
            }

            return ByteVariable(instance);
        }
      },
    );
