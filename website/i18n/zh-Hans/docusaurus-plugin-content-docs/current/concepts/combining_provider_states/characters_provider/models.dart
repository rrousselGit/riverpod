
class Character {
  Character();

  // ignore: avoid_unused_constructor_parameters
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character();
  }
}

class Configuration {
  Configuration({
    this.host = '',
  });

  final String host;
}
