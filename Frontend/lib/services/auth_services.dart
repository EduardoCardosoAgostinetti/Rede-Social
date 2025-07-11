import 'dart:convert';
import 'package:http/http.dart' as http;

final String baseUrl = 'http://192.168.0.101:3000';

class RegisterService {
  Future<http.Response> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }
}

class LoginService {
  Future<http.Response> login(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }
}

class ForgotPasswordService {
  Future<http.Response> sendResetCode(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/codes/request');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}

class VerifyCodeService {
  Future<http.Response> verifyResetCode(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/codes/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}

class ResetPasswordService {
  Future<http.Response> resetPassword(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/codes/resetPass');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}

class UpdateNicknameService {
  Future<http.Response> update(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/nickname');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }
}

class UpdateUsernameService {
  Future<http.Response> update(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/username');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }
}

class UpdatePasswordService {
  Future<http.Response> update(String token, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/users/password');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }
}
