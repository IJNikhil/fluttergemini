import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/chat_message_model.dart';
import '../utils/constants.dart';

class ChatRepo {
  static Future<String> chatTextGenerationRepo(
    List<ChatMessageModel> previousMessages,
  ) async {
    try {
      Dio dio = Dio();

      final response = await dio.post(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro-001:generateContent?key=${apiKey}",
        data: {
          "contents": previousMessages.map((e) => e.toMap()).toList(),
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        },
      );

      log(response.toString());

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final candidate = response.data['candidates'] as List?;
        if (candidate != null && candidate.isNotEmpty) {
          final content = candidate.first['content'] as Map?;
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              return parts.first['text'] as String? ?? '';
            }
          }
        }
      }
      throw Exception('Failed to extract chat text from response.');
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to generate chat text: $e');
    }
  }
}
