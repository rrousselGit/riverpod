class BuildYamlOptions {
  BuildYamlOptions({
    this.providerNameSuffix,
  });

  factory BuildYamlOptions.fromMap(Map<String, dynamic> map) {
    return BuildYamlOptions(
      providerNameSuffix: map['provider_name_suffix'] as String?,
    );
  }

  final String? providerNameSuffix;
}

extension CaseChangeExtension on String {
  String get titled {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }

  String get lowerFirst {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toLowerCase(),
    );
  }

  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}
