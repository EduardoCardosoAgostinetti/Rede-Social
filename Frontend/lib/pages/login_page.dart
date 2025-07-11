import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../services/auth_services.dart';
import '../services/loading_services.dart';
import '../services/language_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/websocket_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _rememberMe = false;

  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        usernameController.text = prefs.getString('username') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _saveLogin(
    String username,
    String nickname,
    String email,
    String password,
    String token,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('password', password);
    } else {
      await prefs.clear();
    }
    await prefs.setString('authToken', token);
    await prefs.setString('username', username);
    await prefs.setString('nickname', nickname);
    await prefs.setString('email', email);
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      try {
        final loc = AppLocalizations.of(context)!;

        showLoadingDialog(context, message: loc.accessing);
        final response = await _loginService.login(data);
        final decoded = jsonDecode(response.body);
        final success = decoded['success'];
        final code = decoded['code'];

        final messageTranslated = translateCode(loc, code);

        if (success) {
          final content = decoded['data']['content'];
          final token = content['token'];
          final user = content['user'];
          final username = user['username'];
          final nickname = user['nickname'];
          final email = user['email'];

          await _saveLogin(
            usernameController.text,
            nickname,
            email,
            passwordController.text,
            token,
          );

          Navigator.pop(context);

          WebSocketService().connect(token);

          Navigator.pushNamed(
            context,
            '/menu',
            arguments: {
              'username': username,
              'nickname': nickname,
              'email': email,
              'token': token,
            },
          );
        } else {
          Navigator.pop(context);
          _showErrorDialog(messageTranslated);
        }
      } catch (e) {
        final loc = AppLocalizations.of(context)!;
        Navigator.pop(context);
        _showErrorDialog(loc.networkError);
      }
    }
  }

  void _showErrorDialog(String message) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[50],
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text(
              loc.error,
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(message, style: TextStyle(color: Colors.red[900])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.ok, style: TextStyle(color: Colors.red[800])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        loc.login,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: loc.username),
                        validator: (value) =>
                            value!.isEmpty ? loc.enterUsername : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: loc.password),
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? loc.enterPassword : null,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(loc.rememberLogin),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                          ),
                          child: Text(loc.forgotPassword),
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(loc.login),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                        ),
                        child: Text(loc.noAccountRegister),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
