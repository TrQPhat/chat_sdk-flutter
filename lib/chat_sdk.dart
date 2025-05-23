library tqp_chat_sdk;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tqp_chat_sdk/error_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class ChatSdk {
  /// Mở chat bằng URL (dùng launchUrl)
  static Future<Widget?> openChat({
    required BuildContext context,
    String name = "",
    String phone = "",
    String email = "",
    String chatUrl = 'https://uat-chatbot.midesk.vn/test/livechatmobie',
    bool useExternal = false,
  }) async {
    final queryParams = <String, String>{
      if (name.isNotEmpty) 'name': name,
      if (phone.isNotEmpty) 'phone': phone,
      if (email.isNotEmpty) 'email': email,
    };

    final url = queryParams.isNotEmpty
        ? Uri.parse(chatUrl).replace(queryParameters: queryParams)
        : Uri.parse(chatUrl);

    return await openChatWithUri(
        context: context, chatUri: url, useExternal: useExternal);
  }

  /// Mở chat bằng Uri có sẵn (hỗ trợ cả WebView và trình duyệt ngoài, mặc định là mở trong app)
  static Future<Widget?> openChatWithUri({
    required BuildContext context,
    required Uri chatUri,
    bool useExternal = false,
  }) async {
    if (kIsWeb) {
      useExternal =
          true; // Chỉ mở trình duyệt ngoài trên Android, Linux và MacOS
    }
    if (useExternal) {
      await _launchUrl(chatUri, useExternal: true);
      Navigator.of(context).pop();
      return null;
    } else {
      try {
        return await getChatDialog(context, chatUri).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Quá thời gian chờ hiển thị chat.');
          },
        );
      } catch (e) {
        return ChatErrorView(onRetry: () {
          // Thử lại khi có lỗi
          Navigator.of(context).pop(); // Đóng dialog lỗi
          openChatWithUri(
              context: context, chatUri: chatUri, useExternal: true);
        });
      }
    }
  }

  /// Hàm mở URL bằng trình duyệt
  static Future<void> _launchUrl(Uri url, {required bool useExternal}) async {
    try {
      final mode = useExternal
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView;
      if (!await launchUrl(url, mode: mode)) {
        throw Exception('Không thể mở URL: $url');
      }
    } catch (e) {
      throw Exception('Lỗi khi mở URL: $e');
    }
  }

  /// Tạo dialog hiển thị chat với WebView
  static Future<Widget> getChatDialog(BuildContext context, Uri uri) async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(uri);
    return WebViewWidget(
      controller: controller,
    );
  }
}
