import 'package:riverpod_generator/src/models.dart';
import 'package:test/test.dart';

void main() {
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
}
