import 'dart:convert';
import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/responsive_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../services/language_services.dart';
import './menu/home_page.dart';
import './menu/friends_page.dart';
import './menu/settings_page.dart';
import 'menu/chats_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with RouteAware {
  String selectedPage = 'home';
  String? uploadedAvatarUrl;

  late String userId;
  late String token;

  String _username = '@unknown';
  String _nickname = 'User';
  String _email = 'no@email.com';

  final String baseUrl = 'http://192.168.0.101:3000/uploads/profile';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      token = args['token'];
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = decodedToken['id'].toString();

      await _loadUserInfo();
      await _loadAvatarForUser();
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '@unknown';
      _nickname = prefs.getString('nickname') ?? 'User';
      _email = prefs.getString('email') ?? 'no@email.com';
      uploadedAvatarUrl = prefs.getString('uploaded_avatar_url_$userId');
    });
  }

  Future<void> _loadAvatarForUser() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final imageUrl = '$baseUrl/$userId.jpeg?$now';

      final response = await http.head(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        setState(() {
          uploadedAvatarUrl = imageUrl;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uploaded_avatar_url_$userId', imageUrl);
      } else {
        setState(() {
          uploadedAvatarUrl = null;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('uploaded_avatar_url_$userId');
      }
    } catch (e) {
      setState(() {
        uploadedAvatarUrl = null;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final uri = Uri.parse(
      'http://192.168.0.101:3000/uploads/uploadProfilePhoto',
    );
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: picked.name,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          picked.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final loc = AppLocalizations.of(context)!;

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      final decoded = jsonDecode(responseData.body);
      final code = decoded['code'] ?? '';
      final messageTranslated = translateCode(loc, code);

      if (response.statusCode == 200 &&
          (decoded['success'] == true || decoded['success'] == null)) {
        // Sucesso no upload
        final imageUrl =
            'http://192.168.0.101:3000${decoded['data']['imageUrl']}';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uploaded_avatar_url_$userId', imageUrl);

        setState(() {
          uploadedAvatarUrl =
              '$imageUrl?${DateTime.now().millisecondsSinceEpoch}';
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(messageTranslated)));
      } else {
        // Caso de erro da API, mostra mensagem traduzida
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(messageTranslated)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${loc.error}: $e')));
    }
  }

  Widget _buildContent() {
    switch (selectedPage) {
      case 'friends':
        return FriendsPage();
      case 'settings':
        return SettingsPage();
      case 'chat':
        return ChatsPage();
      case 'home':
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final fallbackAvatar =
        'https://tse3.mm.bing.net/th/id/OIP.7dTfyRneXPY5b7pj0NKuUgHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3';

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: uploadedAvatarUrl != null
                              ? NetworkImage(uploadedAvatarUrl!)
                              : NetworkImage(fallbackAvatar),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nickname,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@$_username',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(_email, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MenuButton(
                        icon: Icons.home,
                        label: loc.home,
                        selected: selectedPage == 'home',
                        onTap: () => setState(() => selectedPage = 'home'),
                      ),
                      _MenuButton(
                        icon: Icons.group,
                        label: loc.friends,
                        selected: selectedPage == 'friends',
                        onTap: () => setState(() => selectedPage = 'friends'),
                      ),
                      _MenuButton(
                        icon: Icons.chat,
                        label: loc.chats,
                        selected: selectedPage == 'chat',
                        onTap: () => setState(() => selectedPage = 'chat'),
                      ),
                      _MenuButton(
                        icon: Icons.settings,
                        label: loc.settings,
                        selected: selectedPage == 'settings',
                        onTap: () => setState(() => selectedPage = 'settings'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
