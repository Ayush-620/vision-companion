import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqVisionService {
  static const String _endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  static const String _model =
      'qwen/qwen3.6-27b';

  Future<String> analyzeImage(Uint8List imageBytes) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Groq API key is not configured.');
    }

    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    'Describe this image for a vision companion app. '
                    'Identify the main objects, people, and important surroundings. '
                    'Use simple language suitable for spoken audio. '
                    'Do not speculate about things you cannot clearly see. '
                    'Do not mention that you are analyzing an image. '
                    'Return only the final description. '
                    'Do not include reasoning, <think> tags, headings, or bullet points.',
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'reasoning_effort': 'none',
        'reasoning_format': 'hidden',
        'temperature': 0.2,
        'max_completion_tokens': 300,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Groq API error (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final content = data['choices']?[0]?['message']?['content'];

    if (content is! String || content.trim().isEmpty) {
      throw Exception('No analysis result returned by Groq.');
    }

    return content.trim();
  }
}