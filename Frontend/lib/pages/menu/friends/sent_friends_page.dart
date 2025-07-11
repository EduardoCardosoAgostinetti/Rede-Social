import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/friendship_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart'; // para translateCode

class SentFriendsPage extends StatefulWidget {
  const SentFriendsPage({super.key});

  @override
  State<SentFriendsPage> createState() => _SentFriendsPageState();
}

class _SentFriendsPageState extends State<SentFriendsPage> {
  final FriendshipService _service = FriendshipService();

  List<Map<String, dynamic>> _sentRequests = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchSentRequests();
  }

  Future<void> fetchSentRequests() async {
    setState(() {
      _loading = true;
      _sentRequests = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final loc = AppLocalizations.of(context)!;

    if (token == null) {
      showAlert(loc.tokenNotFound, success: false);
      setState(() => _loading = false);
      return;
    }

    try {
      final result = await _service.getSentPendingFriendRequests(token);

      final code = result['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      setState(() {
        _loading = false;
      });

      if (result['success'] == true) {
        final users = result['data']['content'];
        if (users is List) {
          setState(() {
            _sentRequests = List<Map<String, dynamic>>.from(users);
          });
        } else {
          setState(() {
            _sentRequests = [];
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

  void showAlert(String message, {bool success = true}) {
    final loc = AppLocalizations.of(context)!;

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _sentRequests.isEmpty
            ? Center(
                child: Text(
                  loc.noPendingSentRequests,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _sentRequests.length,
                itemBuilder: (context, index) {
                  final request = _sentRequests[index];
                  final receiver = request['receiver'];
                  final nickname = receiver?['nickname'] ?? loc.unknownNickname;
                  final id = receiver?['id']?.toString() ?? loc.unknownId;

                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.network(
                            'http://192.168.0.101:3000/uploads/profile/${id}.jpeg?${DateTime.now().millisecondsSinceEpoch}',
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
                      trailing: Text(loc.pending),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
