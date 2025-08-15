import 'package:riverpod_generator/src/models.dart';
import 'package:test/test.dart';

void main() {
  test('default options', () {
    final options = BuildYamlOptions.fromMap({});

    expect(options.providerNamePrefix, '');
    expect(options.providerFamilyNamePrefix, '');
    expect(options.providerNameSuffix, 'Provider');
    expect(options.providerFamilyNameSuffix, 'Provider');
    expect(options.providerNameStripPattern, r'Notifier$');
  });

  test('custom suffix', () async {
    const map = {'provider_name_suffix': 'Pod'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerNameSuffix, 'Pod');
  });

  test('custom family suffix', () async {
    const map = {'provider_family_name_suffix': 'ProviderFamily'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerFamilyNameSuffix, 'ProviderFamily');
  });

  test('custom prefix', () async {
    const map = {'provider_name_prefix': 'my'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerNamePrefix, 'my');
  });

  test('custom family prefix', () async {
    const map = {'provider_family_name_prefix': 'myFamily'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerFamilyNamePrefix, 'myFamily');
  });

  test('provider name strip pattern', () async {
    const map = {'provider_name_strip_pattern': r'Foo$'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerNameStripPattern, r'Foo$');
  });

  test('provider name strip pattern with multiple patterns', () async {
    const map = {'provider_name_strip_pattern': r'(Notifier|Controller)$'};
    final options = BuildYamlOptions.fromMap(map);
    expect(options.providerNameStripPattern, r'(Notifier|Controller)$');
  });
}
