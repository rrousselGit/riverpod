import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    return '''
final ${data.providerName} = Provider<${data.valueDisplayType}>((ref) {
  throw UnimplementedError();
});''';
  }
}
