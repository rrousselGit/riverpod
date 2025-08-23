class BuildYamlOptions {
  BuildYamlOptions({
    required this.providerNamePrefix,
    required this.providerFamilyNamePrefix,
    required this.providerNameSuffix,
    required this.providerFamilyNameSuffix,
    required this.providerNameStripPattern,
  });

  factory BuildYamlOptions.fromMap(Map<String, dynamic> map) {
    return BuildYamlOptions(
      providerNamePrefix: (map['provider_name_prefix'] as String?) ?? '',
      providerFamilyNamePrefix:
          (map['provider_family_name_prefix'] as String?) ?? '',
      providerNameSuffix:
          (map['provider_name_suffix'] as String?) ?? 'Provider',
      providerFamilyNameSuffix:
          (map['provider_family_name_suffix'] as String?) ?? 'Provider',
      providerNameStripPattern:
          (map['provider_name_strip_pattern'] as String?) ?? r'Notifier$',
    );
  }

  final String providerNamePrefix;
  final String providerFamilyNamePrefix;
  final String providerNameSuffix;
  final String providerFamilyNameSuffix;
  final String providerNameStripPattern;
}
