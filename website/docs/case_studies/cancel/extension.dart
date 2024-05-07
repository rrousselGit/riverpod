import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/* SNIPPET START */
extension DebounceAndCancelExtension on Ref {
  // {@template note}
  /// Wait for [duration] (defaults to 500ms), and then return a [http.Client]
  /// which can be used to make a request.
  ///
  /// That client will automatically be closed when the provider is disposed.
  // {@endtemplate}
  Future<http.Client> getDebouncedHttpClient([Duration? duration]) async {
    // {@template didDispose}
    // First, we handle debouncing.
    // {@endtemplate}
    var didDispose = false;
    onDispose(() => didDispose = true);

    // {@template delay}
    // We delay the request by 500ms, to wait for the user to stop refreshing.
    // {@endtemplate}
    await Future<void>.delayed(duration ?? const Duration(milliseconds: 500));

    // {@template cancel}
    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    // {@endtemplate}
    if (didDispose) {
      throw Exception('Cancelled');
    }

    // {@template client}
    // We now create the client and close it when the provider is disposed.
    // {@endtemplate}
    final client = http.Client();
    onDispose(client.close);

    // {@template return}
    // Finally, we return the client to allow our provider to make the request.
    // {@endtemplate}
    return client;
  }
}
