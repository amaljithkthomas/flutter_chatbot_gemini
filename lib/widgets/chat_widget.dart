import 'package:chatbot_gemini/widgets/message_widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final String? apiKey;
  const ChatWidget({
    Key? key,
    required this.apiKey,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late TextEditingController _textEditingController;
  final FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.apiKey?.isNotEmpty ?? false
                ? ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return MessageWidget();
                    })
                : ListView(
                    children: const [
                      Text(
                          'Api key is not available please get it from google AI studio ')
                    ],
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: _textEditingController,
                  focusNode: _textFieldFocus,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Enter something...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox.square(
                dimension: 15,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.image,
                  color: theme.colorScheme.secondary,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: theme.colorScheme.primary,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
