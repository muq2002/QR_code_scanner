import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the URL from the route arguments, defaulting to an empty string if it's null
    final String? url = ModalRoute.of(context)?.settings.arguments as String?;
    // Check if the URL is null
    if (url == null) {
      // Handle the case where the URL is null
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text('No URL provided.'),
        ),
      );
    }

    // Create a WebViewController and configure it
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Handle loading progress
          },
          onPageStarted: (String url) {
            // Optional: Handle page started event
          },
          onPageFinished: (String url) {
            // Optional: Handle page finished event
          },
          onWebResourceError: (WebResourceError error) {
            // Optional: Handle web resource error
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    // Return a Scaffold widget with an app bar and a WebViewWidget
    return Scaffold(
      appBar: AppBar(title: Text('Web View')),
      body: WebViewWidget(controller: controller),
    );
  }
}
