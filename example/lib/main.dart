import 'package:flutter/material.dart';
import 'package:tqp_chat_sdk/midesk_chat_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat SDK Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Demo Chat SDK')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              ChatSdk.openChat(
                name: 'Nguyen Van A',
                phone: '0909123456',
                email: 'vana@gmail.com',
              );
            },
            child: const Text('Mở Chat'),
          ),
        ),
      ),
    );
  }
}
