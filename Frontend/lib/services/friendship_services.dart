import 'dart:convert';
import 'package:http/http.dart' as http;

final String baseUrl = 'http://192.168.0.101:3000';

class FriendshipService {
  Future<Map<String, dynamic>> searchByNickname(String nickname) async {
    final url = Uri.parse('$baseUrl/friendships/searchByNickname/$nickname');
    final response = await http.get(url);

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> sendFriendRequest(
    String receiverId,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/friendships/sendFriendRequest');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'receiverId': receiverId}),
    );

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getSentPendingFriendRequests(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/friendships/getSentPendingFriendRequests');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getPendingFriendRequests(String token) async {
    final url = Uri.parse('$baseUrl/friendships/getPendingFriendRequests');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> respondToFriendRequest(
    String token,
    String requestId,
    String action,
  ) async {
    final url = Uri.parse('$baseUrl/friendships/respondToFriendRequest');

    final body = jsonEncode({'requestId': requestId, 'action': action});

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    final data = jsonDecode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getFriends(String token) async {
    final url = Uri.parse('$baseUrl/friendships/getFriends');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    return data;
  }
}
