import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hansungunivnotinoti/widgets/web_view/web_loading_indicator_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.link});
  final String link;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final WebViewController _webViewController = WebViewController();

  ValueNotifier<int> currentProgressNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        currentProgressNotifier.value = 0;
      },
      onProgress: (progress) {
        currentProgressNotifier.value = progress;
      },
      onPageFinished: (url) async {
        currentProgressNotifier.value = 100;
      },
    ));
    _webViewController.setBackgroundColor(Colors.white);
    _webViewController.loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.left_chevron,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          CupertinoButton(
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              CupertinoIcons.globe,
              size: 22,
              color: Color(0xFF666666),
            ),
            onPressed: () async {
              String? currentUrl = await _webViewController.currentUrl();
              if (currentUrl != null) {
                if (await canLaunchUrl(Uri.parse(currentUrl))) {
                  launchUrl(
                    Uri.parse(currentUrl),
                    mode: LaunchMode.externalApplication,
                  );
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          ValueListenableBuilder(
            valueListenable: currentProgressNotifier,
            builder: (context, currentProgress, child) {
              return WebLoadingIndicatorWidget(currentProgress: currentProgress);
            },
          ),
        ],
      ),
    );
  }
}
