import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:app/services/auth_services.dart';
import 'package:app/services/loading_services.dart';
import 'package:app/services/language_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/responsive_services.dart';

class EditAccountInfoPage extends StatefulWidget {
  const EditAccountInfoPage({super.key});

  @override
  State<EditAccountInfoPage> createState() => _EditAccountInfoPageState();
}

class _EditAccountInfoPageState extends State<EditAccountInfoPage> {
  String? _token;
  String? _username;
  String? _nickname;

  final _nicknameService = UpdateNicknameService();
  final _usernameService = UpdateUsernameService();
  final _passwordService = UpdatePasswordService();

  @override
  void initState() {
    super.initState();
    _loadTokenAndUserData();
  }

  Future<void> _loadTokenAndUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('authToken');
      _username = prefs.getString('username');
      _nickname = prefs.getString('nickname');
    });
  }

  void _showErrorDialog(String message) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[50],
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
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

  Future<void> _showEditDialog({
    required String title,
    required String label,
    required Function(String) onSubmit,
    bool obscure = false,
  }) async {
    final controller = TextEditingController();
    final loc = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await onSubmit(controller.text.trim());
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNickname(String nickname) async {
    final loc = AppLocalizations.of(context)!;
    if (_token == null || nickname.isEmpty) return;

    try {
      showLoadingDialog(context, message: loc.updatingNickname);
      final response = await _nicknameService.update(_token!, {
        'nickname': nickname,
      });
      Navigator.pop(context);

      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      final code = decoded['code'];

      final message = translateCode(loc, code);

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nickname', nickname);
        setState(() => _nickname = nickname);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.nicknameUpdated)));
      } else {
        _showErrorDialog(message);
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(loc.networkError);
    }
  }

  Future<void> _updateUsername(String username) async {
    final loc = AppLocalizations.of(context)!;
    if (_token == null || username.isEmpty) return;

    try {
      showLoadingDialog(context, message: loc.updatingUsername);
      final response = await _usernameService.update(_token!, {
        'username': username,
      });
      Navigator.pop(context);

      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      final code = decoded['code'];
      final message = translateCode(loc, code);

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        setState(() => _username = username);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.usernameUpdated)));
      } else {
        _showErrorDialog(message);
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(loc.networkError);
    }
  }

  Future<void> _updatePassword(String current, String newPassword) async {
    final loc = AppLocalizations.of(context)!;
    if (_token == null || current.isEmpty || newPassword.isEmpty) return;

    try {
      showLoadingDialog(context, message: loc.updatingPassword);
      final response = await _passwordService.update(_token!, {
        'oldPassword': current,
        'newPassword': newPassword,
      });
      Navigator.pop(context);

      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      final code = decoded['code'];
      final message = translateCode(loc, code);

      if (success) {
        // Por segurança, não armazene a senha aqui.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.passwordUpdated)));
      } else {
        _showErrorDialog(message);
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(loc.networkError);
    }
  }

  void _showPasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.updatePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(labelText: loc.currentPassword),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(labelText: loc.newPassword),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updatePassword(
                currentController.text.trim(),
                newController.text.trim(),
              );
            },
            child: Text(loc.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(
        label.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.editProfile)),
      body: ResponsiveWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.chooseFieldToUpdate,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),

              // Nickname
              _buildEditButton(
                label: '${loc.nickname}: ${_nickname ?? ''}',
                icon: Icons.person,
                onPressed: () => _showEditDialog(
                  title: loc.updateNickname,
                  label: loc.nickname,
                  onSubmit: _updateNickname,
                ),
              ),
              const SizedBox(height: 12),

              // Username
              _buildEditButton(
                label: '${loc.username}: ${_username ?? ''}',
                icon: Icons.alternate_email,
                onPressed: () => _showEditDialog(
                  title: loc.updateUsername,
                  label: loc.username,
                  onSubmit: _updateUsername,
                ),
              ),
              const SizedBox(height: 12),

              // Password
              _buildEditButton(
                label: loc.updatePassword,
                icon: Icons.lock,
                onPressed: _showPasswordDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
