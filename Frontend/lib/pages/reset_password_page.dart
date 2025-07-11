import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth_services.dart';
import '../services/loading_services.dart';
import '../services/language_services.dart';
import 'package:app/l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ResetPasswordService _resetPasswordService = ResetPasswordService();

  late String email;
  late String code;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    email = args['email']!;
    code = args['code']!;
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    try {
      showLoadingDialog(context, message: loc.resettingPassword);

      final response = await _resetPasswordService.resetPassword({
        'email': email,
        'code': code,
        'newPassword': passwordController.text.trim(),
      });

      Navigator.pop(context); // fecha o loading

      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      final int? apiCode = decoded['code'];
      final messageFromApi = decoded['message'] ?? '';
      final msgData = decoded['data']?['msg'];

      final messageTranslated = apiCode != null
          ? translateCode(loc, apiCode)
          : (msgData ?? messageFromApi ?? loc.somethingWentWrong);

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
                onPressed: () {
                  Navigator.pop(context); // fecha dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: Text(
                  loc.backToLogin,
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
            ],
          ),
        );
      } else {
        _showErrorDialog(messageTranslated);
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(loc.networkError);
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
          padding: const EdgeInsets.all(16),
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
                        loc.resetPassword,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: loc.newPassword),
                        validator: (value) => value != null && value.length >= 6
                            ? null
                            : loc.passwordMinChars,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: loc.confirmPassword,
                        ),
                        validator: (value) => value == passwordController.text
                            ? null
                            : loc.passwordsDoNotMatch,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(loc.changePassword),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                        ),
                        child: Text(loc.rememberPasswordBackToLogin),
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
