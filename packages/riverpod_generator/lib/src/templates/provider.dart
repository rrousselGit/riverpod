import '../models.dart';

class ProviderTemplate {
  ProviderTemplate(this.data);
  final Data data;

  @override
  String toString() {
    return 'class ${data.name} {}';
  }
}
