import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shimmer/shimmer.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const WebViewNewsScreen(url: 'https://peared-client.vercel.app'),
    );
  }
}

class WebViewNewsScreen extends StatefulWidget {
  const WebViewNewsScreen({super.key, required this.url});

  final String url;

  @override
  State<WebViewNewsScreen> createState() => _WebViewNewsScreenState();
}

class _WebViewNewsScreenState extends State<WebViewNewsScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildWebView(),
            if (_isLoading) _buildShimmerLoader(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        allowsInlineMediaPlayback: true,
        supportZoom: false,

      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (_, __) => setState(() => _isLoading = true),
      onLoadStop: (_, __) => setState(() => _isLoading = false),
      onLoadError: (_, __, ___, message) {
        debugPrint("WebView error: $message");
        setState(() => _isLoading = false); // Hide shimmer in case of error
      },
    );
  }

  Widget _buildShimmerLoader() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(height: 20, width: 200, color: Colors.white),
              const SizedBox(height: 10),
              Container(height: 300, width: double.infinity, color: Colors.white),
              const SizedBox(height: 10),
              Container(height: 20, width: 300, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _webViewController?.clearCache();
    _webViewController?.dispose();
    super.dispose();
  }
}
