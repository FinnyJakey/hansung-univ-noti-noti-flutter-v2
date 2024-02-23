import 'package:flutter/material.dart';

class WebLoadingIndicatorWidget extends StatefulWidget {
  const WebLoadingIndicatorWidget({super.key, required this.currentProgress});
  final int currentProgress;

  @override
  State<WebLoadingIndicatorWidget> createState() => _WebLoadingIndicatorWidgetState();
}

class _WebLoadingIndicatorWidgetState extends State<WebLoadingIndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.currentProgress < 100
        ? LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: const Color(0xFFF4F4F4),
            color: Colors.grey,
            value: widget.currentProgress / 100.0,
          )
        : const SizedBox.shrink();
  }
}
