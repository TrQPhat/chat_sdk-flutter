library tqp_chat_sdk;

import 'package:url_launcher/url_launcher.dart';

class ChatSdk {
  static Future<void> openChat({
    required String name,
    required String phone,
    required String email,
    bool useExternal = false,
  }) async {
    final Uri url = Uri.parse(
      'https://uat-chatbot.midesk.vn/test/livechatmobie'
      '?name=${Uri.encodeComponent(name)}'
      '&phone=${Uri.encodeComponent(phone)}'
      '&email=${Uri.encodeComponent(email)}',
    );

    final bool canLaunchUrlFlag = await canLaunchUrl(url);
    if (!canLaunchUrlFlag) {
      throw 'Không thể mở link: $url';
    }

    await launchUrl(
      url,
      mode: useExternal
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView,
    );
  }
}
