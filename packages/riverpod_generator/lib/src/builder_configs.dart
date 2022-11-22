/// The parsed configuration given to the builder.
class BuilderConfigs {
  const BuilderConfigs({
    required this.providerPostfix,
  });

  factory BuilderConfigs.fromJson(Map<String, dynamic> json) {
    return BuilderConfigs(
      providerPostfix: json['providerPostfix'] as String? ?? 'Provider',
    );
  }

  /// The postfix to use to name the generated providers.
  ///
  /// Default to `'Provider'`.
  final String providerPostfix;
}
