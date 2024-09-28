import 'dart:convert';
import 'dart:io';

import 'package:riverpod/riverpod.dart';

@riverpod
Future<Model> model(Ref ref) async {
  final response = await ref.client.get('https://api.example.com/model');
}

extension on Ref {
  RefAwareClient get client => RefAwareClient(this);
}

class RefAwareHttpClient {
  RefAwareHttpClient(this._ref);

  final Ref _ref;
  final HttpClient _client = HttpClient();

  Future<http.Response> getUri(Uri uri) async {
    final response = await _client.getUrl(uri);
    response.done.then((body) => setCache(body));

    if (hasCache(uri)) {
      response.done.then((_) => ref.invalidateSelf());

      return cache;
    }

    return response;
  }
}

class DecodedHttpClientResponse {
  final int statusCode;
  final Map<String, List<String>> headers;
  final List<int> body;

  DecodedHttpClientResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  @override
  String toString() {
    return 'Status: $statusCode\nHeaders: $headers\nBody: ${utf8.decode(body)}';
  }
}

Future<DecodedHttpClientResponse> decodeHttpClientResponseFromFile(
  String filePath,
) async {
  // Read the file content
  File file = File(filePath);
  String encodedResponse = await file.readAsString();

  // Decode the JSON content
  Map<String, dynamic> responseData = jsonDecode(encodedResponse);

  // Extract the status code, headers, and body
  int statusCode = responseData['statusCode'];
  Map<String, List<String>> headers =
      Map<String, List<String>>.from(responseData['headers']);
  List<int> bodyBytes =
      base64Decode(responseData['body']); // Decode Base64-encoded body

  // Return the custom DecodedHttpClientResponse object
  return DecodedHttpClientResponse(
    statusCode: statusCode,
    headers: headers,
    body: bodyBytes,
  );
}
