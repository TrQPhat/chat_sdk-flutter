import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'chat_sdk.dart';

// Thêm enum để quản lý nhiều trạng thái
enum ChatState { loading, loaded, error }

class ChatScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String chatUrl; // URL chat mặc định

  const ChatScreen({
    Key? key,
    this.name = "",
    this.phone = "",
    this.email = "",
    this.chatUrl = 'https://uat-chatbot.midesk.vn/test/livechatmobie',
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _useExternal = true;
  bool _isLoading = true;
  Widget? _chatWidget;
  late Uri _chatUri;

  @override
  void initState() {
    super.initState();
    final queryParams = <String, String>{
      if (widget.name.isNotEmpty) 'name': widget.name,
      if (widget.phone.isNotEmpty) 'phone': widget.phone,
      if (widget.email.isNotEmpty) 'email': widget.email,
    };

    _chatUri = queryParams.isNotEmpty
        ? Uri.parse(widget.chatUrl).replace(queryParameters: queryParams)
        : Uri.parse(widget.chatUrl);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showChoiceDialog();
    });
  }

  Future<void> _showChoiceDialog() async {
    bool choice;

    if (kIsWeb) {
      // Trên desktop, mặc định mở bằng trình duyệt
      choice = true;
    } else {
      // Trên mobile, hỏi người dùng
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Truy cập link chat'),
          content: const Text(
              'Bạn muốn mở chat trong ứng dụng hay sử dụng trình duyệt?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Mở trong app
              child: const Text('Ở lại',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Mở trình duyệt
              child: const Text('Mở bằng trình duyệt'),
            ),
          ],
        ),
      );

      if (result == null) return; // Người dùng không chọn => thoát
      choice = result;
    }

    setState(() {
      _useExternal = choice;
      _isLoading = true;
    });

    // Mở chat
    _chatWidget = await ChatSdk.openChatWithUri(
      context: context,
      chatUri: _chatUri,
      useExternal: _useExternal,
    );

    if (_chatWidget != null) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liên hệ hỗ trợ'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingIndicator() : _chatWidget!,
    );
  }
}

Widget _buildLoadingIndicator() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Đang tải...'),
      ],
    ),
  );
}
