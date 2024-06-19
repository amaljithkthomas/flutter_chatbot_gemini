import 'package:chatbot_gemini/widgets/chat_widget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.title,
    required this.apiKey,
  }) : super(key: key);
  final String title;
  final String? apiKey;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ChatWidget(
        apiKey: widget.apiKey,
      ),
    );
  }
}
