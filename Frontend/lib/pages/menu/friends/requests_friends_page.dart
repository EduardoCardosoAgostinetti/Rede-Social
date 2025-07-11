import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/friendship_services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart';

class RequestsFriendsPage extends StatefulWidget {
  const RequestsFriendsPage({super.key});

  @override
  State<RequestsFriendsPage> createState() => _RequestsFriendsPageState();
}

class _RequestsFriendsPageState extends State<RequestsFriendsPage> {
  final FriendshipService _service = FriendshipService();

  List<Map<String, dynamic>> _requests = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() {
      _loading = true;
      _requests = [];
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
      final result = await _service.getPendingFriendRequests(token);

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
            _requests = List<Map<String, dynamic>>.from(content);
          });
        } else {
          setState(() {
            _requests = [];
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

  Future<void> respondToRequest(String requestId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final loc = AppLocalizations.of(context)!;

    if (token == null) {
      showAlert(loc.tokenNotFound, success: false);
      return;
    }

    try {
      final result = await _service.respondToFriendRequest(
        token,
        requestId,
        action,
      );

      final success = result['success'] ?? false;
      final code = result['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      if (success) {
        showAlert(
          action == 'accept' ? loc.requestAccepted : loc.requestDeclined,
          success: true,
        );
        fetchRequests(); // Atualiza lista
      } else {
        showAlert(messageTranslated, success: false);
      }
    } catch (e) {
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
            : _requests.isEmpty
            ? Center(
                child: Text(
                  loc.noPendingReceivedRequests,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final request = _requests[index];
                  final requester = request['requester'];
                  final nickname =
                      requester?['nickname'] ?? loc.unknownNickname;
                  final id = requester?['id']?.toString() ?? loc.unknownId;
                  final requestId = request['id'].toString();

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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: loc.accept,
                            onPressed: () =>
                                respondToRequest(requestId, 'accept'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: loc.decline,
                            onPressed: () =>
                                respondToRequest(requestId, 'decline'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
