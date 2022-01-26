import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniBrowser extends ConsumerWidget {
  const MiniBrowser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: WebView(
        onWebViewCreated: (webViewController) =>
          ref.read(webViewProvider.notifier).setWebView(webViewController),
        initialUrl: ref.watch(webPageProvider),
        onWebResourceError: (error) =>
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text("Error with page ${error.failingUrl}",
                    style: const TextStyle(color: Colors.white),),
                backgroundColor: Colors.black,
            )
          ),
        onPageStarted: (url) =>
            ref.read(webPageProvider.notifier).setWebPage(url),
      ),
    );
  }

}