import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

extension SwitchCreatedType on GeneratorProviderDeclaration {
  SupportedCreatedType get createdType {
    final dartType = createdTypeNode?.type;
    switch (dartType) {
      case != null
          when !dartType.isRaw &&
              (dartType.isDartAsyncFutureOr || dartType.isDartAsyncFuture):
        return SupportedCreatedType.future;
      case != null when !dartType.isRaw && dartType.isDartAsyncStream:
        return SupportedCreatedType.stream;
      case _:
        return SupportedCreatedType.value;
    }
  }
}

enum SupportedCreatedType {
  future,
  stream,
  value,
}
