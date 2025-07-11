import 'package:flutter/material.dart';
import 'dart:convert';

import '../services/auth_services.dart';
import '../services/loading_services.dart';
import '../services/language_services.dart';
import 'package:app/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;

  final RegisterService _registerService = RegisterService();

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

  void _register(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        _showErrorDialog(loc.mustAcceptTerms);
        return;
      }

      final data = {
        'username': usernameController.text,
        'email': emailController.text,
        'nickname': nicknameController.text,
        'password': passwordController.text,
      };

      try {
        showLoadingDialog(context, message: loc.registering);
        final response = await _registerService.register(data);

        final decoded = jsonDecode(response.body);
        final success = decoded['success'];
        final int? code = decoded['code'];
        final datar = decoded['data'];
        final msg = datar != null && datar['msg'] != null
            ? datar['msg'] as String
            : '';

        final messageTranslated = code != null
            ? translateCode(loc, code)
            : loc.somethingWentWrong;

        final fullMessage = msg.trim().isNotEmpty
            ? '$messageTranslated: $msg'
            : messageTranslated;

        Navigator.pop(context);

        if (success) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.green[50],
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    loc.success,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text(
                messageTranslated,
                style: TextStyle(color: Colors.green[900]),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    loc.accessNow,
                    style: TextStyle(color: Colors.green[800]),
                  ),
                ),
              ],
            ),
          );
        } else {
          _showErrorDialog(fullMessage);
        }
      } catch (e) {
        Navigator.pop(context);
        _showErrorDialog(loc.networkError);
      }
    }
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
                        loc.register,
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
                        controller: emailController,
                        decoration: InputDecoration(labelText: loc.email),
                        validator: (value) =>
                            value!.isEmpty ? loc.enterEmail : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: nicknameController,
                        decoration: InputDecoration(labelText: loc.nickname),
                        validator: (value) =>
                            value!.isEmpty ? loc.enterNickname : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: loc.password),
                        obscureText: true,
                        validator: (value) =>
                            value!.length < 6 ? loc.minChars : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: loc.confirmPassword,
                        ),
                        obscureText: true,
                        validator: (value) => value != passwordController.text
                            ? loc.passwordsDoNotMatch
                            : null,
                      ),
                      SizedBox(height: 16),
                      CheckboxListTile(
                        value: _acceptedTerms,
                        onChanged: (val) =>
                            setState(() => _acceptedTerms = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          loc.acceptTerms,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _register(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(loc.register),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(loc.alreadyHaveAccount),
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
