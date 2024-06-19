import 'package:chatbot_gemini/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(GenerativeAiSample(
    apiKey: dotenv.env['API_KEY'],
  ));
}

class GenerativeAiSample extends StatelessWidget {
  const GenerativeAiSample({
    Key? key,
    this.apiKey,
  }) : super(key: key);
  final String? apiKey;

  @override
  Widget build(BuildContext context) {
    //print(apiKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My chatbot',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
      ),
      home: ChatScreen(
        apiKey: apiKey,
        title: 'AI Chat bot',
      ),
    );
  }
}
