class Dio {
  List<Product> get(String path) => [];
}

class Product {}

class Configuration {
  Configuration({
    this.host = '',
  });

  final String host;
}
