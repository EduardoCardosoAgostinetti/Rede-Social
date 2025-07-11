import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/friendship_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/websocket_services.dart';
import 'package:app/services/chat_services.dart';
import 'package:app/pages/menu/chats/private_chat_page.dart';
import 'package:intl/intl.dart';
import 'package:app/services/language_services.dart';

class MyFriendsPage extends StatefulWidget {
  const MyFriendsPage({super.key});

  @override
  State<MyFriendsPage> createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  final FriendshipService _service = FriendshipService();

  List<Map<String, dynamic>> _friends = [];
  bool _loading = false;

  StreamSubscription? _presenceSub;

  @override
  void initState() {
    super.initState();
    fetchFriends().then((_) {
      _startListeningPresenceUpdates();
    });
  }

  Future<void> fetchFriends() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _friends = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final loc = AppLocalizations.of(context)!;

    if (token == null) {
      if (!mounted) return;
      showAlert(loc.tokenNotFound, success: false);
      setState(() => _loading = false);
      return;
    }

    try {
      final result = await _service.getFriends(token);

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      final success = result['success'] ?? false;
      final code = result['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      if (success) {
        final content = result['data']?['content'];
        if (content is List) {
          setState(() {
            _friends = List<Map<String, dynamic>>.from(content);
          });
        } else {
          setState(() {
            _friends = [];
          });
        }
      } else {
        showAlert(messageTranslated, success: false);
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showAlert(loc.networkError, success: false);
    }
  }

  void _startListeningPresenceUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    if (token == null) return;

    _presenceSub = WebSocketService().presenceStream.listen((presenceUpdate) {
      if (!mounted) return;

      final userId = presenceUpdate['userId'];
      final status = presenceUpdate['status'];
      final lastLoginAt = presenceUpdate['lastLoginAt'];

      setState(() {
        for (var friend in _friends) {
          if (friend['id'] == userId) {
            friend['presence'] ??= {};
            friend['presence']['status'] = status;
            friend['presence']['lastLoginAt'] = lastLoginAt;
            break;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _presenceSub?.cancel();
    super.dispose();
  }

  void showAlert(String message, {bool success = true}) {
    final loc = AppLocalizations.of(context)!;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: success ? Colors.green[50] : Colors.red[50],
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              success ? loc.success : loc.error,
              style: TextStyle(
                color: success ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: success ? Colors.green[900] : Colors.red[900],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.ok,
              style: TextStyle(
                color: success ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(String lastLoginAtStr) {
    try {
      final date = DateTime.parse(lastLoginAtStr).toLocal();
      final formatted = DateFormat.yMd().add_jm().format(date);
      final loc = AppLocalizations.of(context)!;
      return loc.lastSeen(formatted);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _friends.isEmpty
            ? Center(
                child: Text(
                  loc.noFriendsFound,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _friends.length,
                itemBuilder: (context, index) {
                  final friend = _friends[index];
                  final nickname = friend['nickname'] ?? loc.unknownNickname;
                  final presence = friend['presence'];
                  final isOnline =
                      presence != null && presence['status'] == 'online';
                  final statusText = presence == null
                      ? loc.unknownStatus
                      : isOnline
                      ? loc.statusOnline
                      : loc.statusOffline;

                  final lastSeenText =
                      !isOnline && presence?['lastLoginAt'] != null
                      ? _formatLastSeen(presence['lastLoginAt'])
                      : null;

                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.network(
                            'http://192.168.0.101:3000/uploads/profile/${friend['id']}.jpeg?${DateTime.now().millisecondsSinceEpoch}',
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
                      title: Text(nickname),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              color: isOnline ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (lastSeenText != null && lastSeenText.isNotEmpty)
                            Text(
                              lastSeenText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.chat_bubble),
                        tooltip: loc.chat,
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('authToken');
                          if (token == null) return;

                          final friendId = friend['id'];
                          final nickname =
                              friend['nickname'] ?? loc.unknownNickname;

                          final chatService = ChatService();
                          final result = await chatService.getOrCreateChat(
                            friendId,
                            token,
                          );

                          if (result['success']) {
                            final chatId = result['data']['chat']['id'];
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrivateChatPage(
                                  chatId: chatId,
                                  friendId: friendId,
                                  friendName: nickname,
                                ),
                              ),
                            );
                          } else {
                            final code = result['code'] ?? '';
                            final messageTranslated = translateCode(loc, code);
                            showAlert(messageTranslated, success: false);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
