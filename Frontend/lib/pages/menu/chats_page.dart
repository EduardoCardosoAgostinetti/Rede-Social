import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/chat_services.dart';
import 'package:intl/intl.dart';
import 'package:app/pages/menu/chats/private_chat_page.dart';
import 'package:app/services/websocket_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatService _chatService = ChatService();
  List<Map<String, dynamic>> _chats = [];
  bool _loading = false;
  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _loadChats();
    _initWebSocket();
  }

  void _initWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null) {
      _wsSubscription = WebSocketService().messageStream.listen(
        (data) {
          if (data is! Map) return;

          final chatId = data['chatId'];
          final messageData = data['message'];

          if (chatId == null || messageData == null || messageData is! Map)
            return;

          final message = Map<String, dynamic>.from(messageData);

          if (!mounted) return;

          setState(() {
            final index = _chats.indexWhere((chat) => chat['id'] == chatId);
            if (index != -1) {
              _chats[index]['lastMessage'] = message['content'] ?? '';
              _chats[index]['lastMessageAt'] = message['createdAt'] ?? '';
              final updatedChat = _chats.removeAt(index);
              _chats.insert(0, updatedChat);
            }
          });
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
        },
      );
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadChats() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final loc = AppLocalizations.of(context)!;

    if (token == null) {
      setState(() => _loading = false);
      return;
    }

    try {
      final res = await _chatService.getUserChats(token);
      final success = res['success'] ?? false;
      final code = res['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      if (success) {
        setState(() {
          _chats = List<Map<String, dynamic>>.from(res['data']['chats']);
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        _showErrorDialog(messageTranslated);
      }
    } catch (e) {
      setState(() => _loading = false);
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

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.tryParse(timestamp)?.toLocal();
    if (date == null) return '';

    final now = DateTime.now();
    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;
    return isToday
        ? DateFormat.Hm().format(date)
        : DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _chats.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noChatsFound))
          : ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (_, index) {
                final chat = _chats[index];

                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: Image.network(
                        'http://192.168.0.101:3000/uploads/profile/${chat['friendId']}.jpeg?${DateTime.now().millisecondsSinceEpoch}',
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://tse3.mm.bing.net/th/id/OIP.7dTfyRneXPY5b7pj0NKuUgHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(chat['friendName'] ?? 'Desconhecido'),
                  subtitle: Text(chat['lastMessage'] ?? 'Sem mensagens'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDate(chat['lastMessageAt']),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrivateChatPage(
                          chatId: chat['id'],
                          friendId: chat['friendId'],
                          friendName: chat['friendName'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
