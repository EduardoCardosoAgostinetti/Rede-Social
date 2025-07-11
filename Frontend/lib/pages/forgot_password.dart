import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import 'dart:convert';
import '../services/loading_services.dart';
import 'package:app/l10n/app_localizations.dart';
import '../services/language_services.dart'; // Import da função translateCode

class ForgotPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();

  ForgotPasswordPage({super.key});

  void _handleSendCode(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    try {
      showLoadingDialog(context, message: loc.sendingCode);
      final response = await _forgotPasswordService.sendResetCode({
        'email': emailController.text.trim(),
      });

      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      final code = decoded['code'] ?? ''; // Pegando o código da API
      final messageTranslated = translateCode(
        loc,
        code,
      ); // Mensagem traduzida pelo código

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
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/verify-code',
                    arguments: emailController.text.trim(),
                  );
                },
                child: Text(
                  loc.continueText,
                  style: TextStyle(color: Colors.green[800]),
                ),
              ),
            ],
          ),
        );
      } else {
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
            content: Text(
              messageTranslated.isNotEmpty
                  ? messageTranslated
                  : loc.occurredError,
              style: TextStyle(color: Colors.red[900]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.ok, style: TextStyle(color: Colors.red[800])),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
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
          content: Text(
            '${loc.networkError}: $e',
            style: TextStyle(color: Colors.red[900]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.ok, style: TextStyle(color: Colors.red[800])),
            ),
          ],
        ),
      );
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
                        loc.forgotPassword,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: loc.email),
                        validator: (value) =>
                            value!.isEmpty ? loc.enterEmail : null,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _handleSendCode(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(loc.sendCode),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                        ),
                        child: Text(loc.backToLogin),
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
