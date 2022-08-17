import '../models.dart';

class RefTemplate {
  RefTemplate(this.data);
  final Data data;

  @override
  String toString() {
    return '''
typedef ${data.refName} = ${data.refType}<${data.valueDisplayType}>;''';
  }
}
