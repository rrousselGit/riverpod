import '../models.dart';

class RefTemplate {
  RefTemplate(this.data);
  final Data data;

  @override
  String toString() {
    return '''
typedef ${data.refName} = ProviderRef<${data.valueDisplayType}>;''';
  }
}
