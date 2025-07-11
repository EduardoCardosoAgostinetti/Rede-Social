import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/language_services.dart'; // para translateCode

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> loadFeed() async {
    setState(() => isLoading = true);
    final token = await getToken();
    final res = await http.get(
      Uri.parse('http://192.168.0.101:3000/posts/feed'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final success = decoded['success'];
      final code = decoded['code'];
      final loc = AppLocalizations.of(context)!;

      if (success) {
        setState(() {
          posts = decoded['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        final messageTranslated = translateCode(loc, code);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(messageTranslated)));
      }
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar feed')));
    }
  }

  Future<void> createPostDialog() async {
    final contentController = TextEditingController();
    XFile? pickedImage;
    Uint8List? imagePreview;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newPost),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.writeSomething,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      final preview = await image.readAsBytes();
                      setDialogState(() {
                        pickedImage = image;
                        imagePreview = preview;
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: Text(AppLocalizations.of(context)!.selectImage),
                ),
                if (imagePreview != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.memory(imagePreview!, height: 150),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = await getToken();
                final request = http.MultipartRequest(
                  'POST',
                  Uri.parse('http://192.168.0.101:3000/posts/post'),
                );

                request.headers['Authorization'] = 'Bearer $token';
                request.fields['content'] = contentController.text;

                if (pickedImage != null) {
                  final bytes = await pickedImage!.readAsBytes();
                  final fileName = pickedImage!.name;

                  request.files.add(
                    http.MultipartFile.fromBytes(
                      'image',
                      bytes,
                      filename: fileName,
                    ),
                  );
                }

                Navigator.pop(context); // fecha o modal ANTES da requisição

                final res = await request.send();
                final responseString = await res.stream.bytesToString();
                final decoded = jsonDecode(responseString);
                final success = decoded['success'];
                final code = decoded['code'];
                final loc = AppLocalizations.of(context)!;

                if (res.statusCode == 201 && success) {
                  loadFeed();
                } else {
                  final messageTranslated = translateCode(loc, code);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(messageTranslated)));
                }
              },
              child: Text(AppLocalizations.of(context)!.post),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostCard(post) {
    final user = post['User'];
    final imageUrl = post['imageUrl'] != null
        ? 'http://192.168.0.101:3000${post['imageUrl']}'
        : null;
    final createdAt = DateTime.tryParse(post['createdAt'] ?? '');
    final formattedDate = createdAt != null
        ? "${createdAt.day}/${createdAt.month}/${createdAt.year}"
        : "";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: Image.network(
                  'http://192.168.0.101:3000/uploads/profile/${user['id']}.jpeg?${DateTime.now().millisecondsSinceEpoch}',
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
            title: Text(user['nickname'] ?? user['username']),
            subtitle: Text(formattedDate),
          ),
          if (imageUrl != null)
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stack) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post['content']),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.feed),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createPostDialog,
            tooltip: loc.newPost,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadFeed,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: posts.length,
                itemBuilder: (context, index) => buildPostCard(posts[index]),
              ),
            ),
    );
  }
}
