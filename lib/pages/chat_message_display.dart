import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';

class ChatMessageDisplay extends StatelessWidget {
  final List<ChatMessageModel> messages;

  const ChatMessageDisplay({required this.messages, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.amber.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messages[index].role == "user" ? "User" : "GeminiAI",
                  style: TextStyle(
                    fontSize: 18,
                    color: messages[index].role == "user" ? Colors.amber : Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  messages[index].parts.first.text,
                  style: const TextStyle(height: 1.5, fontSize: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
