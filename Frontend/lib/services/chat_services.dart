import 'dart:convert';
import 'package:http/http.dart' as http;

final String baseUrl = 'http://192.168.0.101:3000';

class ChatService {
  Future<Map<String, dynamic>> getOrCreateChat(
    String friendId,
    String token,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chats/private/$friendId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getChatMessages(
    String chatId,
    String token,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> sendMessage(
    String chatId,
    String content,
    String token,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'content': content}),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getUserChats(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/chats/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }
}
