import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    this.text,
    this.image,
    required this.isFromUser,
  }) : super(key: key);
  final String? text;
  final Image? image;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFromUser ? Colors.teal : Colors.redAccent,
              borderRadius: BorderRadius.only(
                topLeft: isFromUser ? const Radius.circular(18) : Radius.zero,
                topRight: isFromUser ? Radius.zero : const Radius.circular(18),
                bottomRight: const Radius.circular(18),
                bottomLeft: const Radius.circular(18),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                if (text case final text?) MarkdownBody(data: text),
                if (image case final image?) image,
              ],
            ),
          ),
        )
      ],
    );
  }
}
