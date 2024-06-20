import 'package:chatbot_gemini/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

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
  late ScrollController _scrollController;
  bool _loading = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final FocusNode _textFieldFocus = FocusNode();
  final List<({String? text, Image? image, bool isFromUser})>
      _generatedContent = [];

  @override
  void initState() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: widget.apiKey ?? '',
    );
    _chat = _model.startChat();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(microseconds: 750),
              curve: Curves.easeInOutCirc,
            ));
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, isFromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, isFromUser: false));
      if (text == null) {
        if (mounted) {
          showErrorMessage('No response from chat bot');
          return;
        } else {
          setState(() {
            _loading = false;
            _scrollDown();
          });
        }
      }
    } catch (e) {
      showErrorMessage(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textEditingController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<dynamic> showErrorMessage(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Something went wrong'),
            content: SingleChildScrollView(
              child: SelectableText(message),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _loading = true;
      });
      try {
        final bytes = await image.readAsBytes();
        final content = [
          Content.multi([
            TextPart(_textEditingController.text.trim()),
            DataPart('image/jpeg', bytes),
          ])
        ];
        _generatedContent.add((
          text: _textEditingController.text,
          image: Image.memory(bytes),
          isFromUser: true,
        ));

        var response = await _model.generateContent(content);
        var text = response.text;
        _generatedContent.add((
          image: null,
          text: text,
          isFromUser: false,
        ));
        if (text == null) {
          if (mounted) {
            showErrorMessage('No response from chat bot');
            return;
          }
        } else {
          setState(() {
            _loading = false;
            _scrollDown();
          });
        }
      } catch (e, st) {
        showErrorMessage(e.toString());

        setState(() {
          _loading = false;
        });
        print(st);
      } finally {
        _textEditingController.clear();
        setState(() {
          _loading = false;
        });
        _textFieldFocus.requestFocus();
      }
    }
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
                    controller: _scrollController,
                    itemCount: _generatedContent.length,
                    itemBuilder: (context, index) {
                      final content = _generatedContent[index];
                      return MessageWidget(
                        isFromUser: content.isFromUser,
                        image: content.image,
                        text: content.text,
                      );
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
                  onSubmitted: _sendMessage,
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
                onPressed: () {
                  _pickImage();
                },
                icon: Icon(
                  Icons.image,
                  color: theme.colorScheme.secondary,
                ),
              ),
              if (!_loading)
                IconButton(
                  onPressed: () {
                    _sendMessage(_textEditingController.text.trim());
                  },
                  icon: Icon(
                    Icons.send,
                    color: theme.colorScheme.primary,
                  ),
                )
              else
                const CircularProgressIndicator(),
            ],
          )
        ],
      ),
    );
  }
}
