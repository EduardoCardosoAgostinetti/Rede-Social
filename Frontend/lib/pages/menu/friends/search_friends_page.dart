import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/friendship_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart'; // para translateCode

class SearchFriendsPage extends StatefulWidget {
  const SearchFriendsPage({super.key});

  @override
  State<SearchFriendsPage> createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final FriendshipService _service = FriendshipService();

  List<Map<String, dynamic>> _usersFound = [];
  bool _loading = false;

  Future<void> searchUser() async {
    final loc = AppLocalizations.of(context)!;
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      showFriendRequestDialog(loc.enterNicknameToSearch, success: false);
      return;
    }

    setState(() {
      _loading = true;
      _usersFound = [];
    });

    try {
      final result = await _service.searchByNickname(nickname);

      final code = result['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      setState(() {
        _loading = false;
      });

      if (result['success'] == true) {
        final users = result['data']['content'];
        if (users is List) {
          setState(() {
            _usersFound = List<Map<String, dynamic>>.from(users);
          });
        } else {
          setState(() {
            _usersFound = [];
          });
        }
      } else {
        showFriendRequestDialog(messageTranslated, success: false);
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showFriendRequestDialog(loc.networkError, success: false);
    }
  }

  Future<void> sendFriendRequest(String receiverId) async {
    final loc = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      showFriendRequestDialog(loc.tokenNotFound, success: false);
      return;
    }

    try {
      final result = await _service.sendFriendRequest(receiverId, token);

      final code = result['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      showFriendRequestDialog(
        messageTranslated,
        success: result['success'] ?? false,
      );
    } catch (e) {
      showFriendRequestDialog(loc.networkError, success: false);
    }
  }

  void showFriendRequestDialog(String message, {bool success = true}) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: loc.nickname,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => searchUser(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: searchUser,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(loc.search),
            ),
            const SizedBox(height: 20),
            if (_usersFound.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _usersFound.length,
                  itemBuilder: (context, index) {
                    final user = _usersFound[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[200],
                          child: ClipOval(
                            child: Image.network(
                              'http://192.168.0.101:3000/uploads/profile/${user['id']}.jpeg',
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
                        title: Text(user['nickname']),

                        trailing: IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () => sendFriendRequest(user['id']),
                          tooltip: loc.sendFriendRequest,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
