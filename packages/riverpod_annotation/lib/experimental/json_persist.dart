import 'dart:convert';

import '../persist.dart';

class JsonPersist implements RiverpodPersist {
  const JsonPersist();
}

/// Implementation detail of [JsonPersist]. Do not use.
const $jsonCodex = json;
