class BuildYamlOptions {
  BuildYamlOptions({
    this.providerNamePrefix,
    this.providerFamilyNamePrefix,
    this.providerNameSuffix,
    this.providerFamilyNameSuffix,
    this.providerNameStripPattern,
  });

  factory BuildYamlOptions.fromMap(Map<String, dynamic> map) {
    return BuildYamlOptions(
      providerNamePrefix: map['provider_name_prefix'] as String?,
      providerFamilyNamePrefix: map['provider_family_name_prefix'] as String?,
      providerNameSuffix: map['provider_name_suffix'] as String?,
      providerFamilyNameSuffix: map['provider_family_name_suffix'] as String?,
      providerNameStripPattern: map['provider_name_strip_pattern'] as String?,
    );
  }

  final String? providerNamePrefix;
  final String? providerFamilyNamePrefix;
  final String? providerNameSuffix;
  final String? providerFamilyNameSuffix;
  final String? providerNameStripPattern;
}

extension CaseChangeExtension on String {
  String get encoded => replaceAll(r'$', r'\$');

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
