import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../utils/app_var.dart';

// ignore: must_be_immutable
class WebViewApp extends StatefulWidget {
  String? link;
  WebViewApp({this.link, super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    log("Loading URL: ${widget.link}");
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Loading progress
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              hasError = true;
              errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation requests
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.link ?? "https://codelabs.developers.google.com/codelabs/flutter-webview#3"),
      );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Reset preferred orientation when the screen is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Method to reload the page
  void _reloadPage() {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: (getStorage.read('isDarkMode') == true) ? ColorValues.appBarColor : ColorValues.whiteColor,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 5,
            left: 20,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                  ),
                ),
              ),
              const Spacer(),
              // Add refresh button
              if (hasError)
                GestureDetector(
                  onTap: _reloadPage,
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.smallContainerBg : Colors.grey.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(11),
                    child: Icon(
                      Icons.refresh,
                      color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          // Loading indicator
          if (isLoading)
            Container(
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: ColorValues.redColor,
                ),
              ),
            ),
          // Error message
          if (hasError && !isLoading)
            Container(
              color: (getStorage.read('isDarkMode') == true) ? ColorValues.scaffoldBg : ColorValues.whiteColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load page',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (getStorage.read('isDarkMode') == true) ? ColorValues.whiteColor : ColorValues.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: (getStorage.read('isDarkMode') == true)
                            ? ColorValues.whiteColor.withValues(alpha: 0.7)
                            : ColorValues.blackColor.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _reloadPage,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
