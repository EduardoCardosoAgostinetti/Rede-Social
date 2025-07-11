import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/chat_services.dart';
import 'package:app/services/websocket_services.dart';
import 'package:app/services/responsive_services.dart';
import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class PrivateChatPage extends StatefulWidget {
  final String chatId;
  final String friendId;
  final String friendName;

  const PrivateChatPage({
    super.key,
    required this.chatId,
    required this.friendId,
    required this.friendName,
  });

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = false;

  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadMessages();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token != null) {
      _wsSubscription = WebSocketService().messageStream.listen(
        (data) {
          if (data is! Map) return;
          if (data['chatId'] != widget.chatId) return;
          final messageData = data['message'];
          if (messageData == null || messageData is! Map) return;

          final newMsg = Map<String, dynamic>.from(messageData);
          final exists = _messages.any((m) => m['id'] == newMsg['id']);
          if (!exists) {
            if (!mounted) return;
            setState(() {
              _messages.add(newMsg);
            });
          }
        },
        onError: (error) {
          debugPrint('WebSocket error in PrivateChatPage: $error');
        },
      );
    }
  }

  Future<void> _loadMessages() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) {
      setState(() => _loading = false);
      return;
    }

    final res = await _chatService.getChatMessages(widget.chatId, token);
    if (res['success']) {
      if (!mounted) return;
      setState(() {
        _messages = List<Map<String, dynamic>>.from(res['data']['content']);
        _loading = false;
      });
    } else {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) return;

    final res = await _chatService.sendMessage(widget.chatId, text, token);
    if (res['success']) {
      _messageController.clear();
    }
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp).toLocal();
      return DateFormat.Hm().format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // OBTÉM LOCALIZAÇÕES

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: Image.network(
                  'http://192.168.0.101:3000/uploads/profile/${widget.friendId}.jpeg?${DateTime.now().millisecondsSinceEpoch}',
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
            const SizedBox(width: 12),
            Text(widget.friendName),
          ],
        ),
      ),

      body: ResponsiveWrapper(
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (_, index) {
                        final msg = _messages[index];
                        final isMe = msg['senderId'] != widget.friendId;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['content'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  _formatDate(msg['createdAt'] ?? ''),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: loc.typeYourMessage, // USANDO TRADUÇÃO
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    tooltip: loc.send,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
