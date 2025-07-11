import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  bool _isConnected = false;

  final _presenceController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get presenceStream => _presenceController.stream;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  void connect(String token) {
    if (_isConnected) return;

    final uri = Uri.parse('ws://192.168.0.101:8080');
    _channel = WebSocketChannel.connect(uri);
    _isConnected = true;

    _channel!.sink.add(token);

    _channel!.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          if (data['type'] == 'presence_update') {
            _presenceController.add(data);
          } else if (data['type'] == 'new_message') {
            _messageController.add(data);
          }
        } catch (e) {
          print('Erro ao decodificar WS: $e');
        }
      },
      onDone: () {
        _isConnected = false;
      },
      onError: (error) {
        print('Erro WebSocket: $error');
        _isConnected = false;
      },
    );
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  void dispose() {
    _presenceController.close();
    _messageController.close();
  }
}
