import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../caching/secure_storage_service.dart';
import '../constants/app_constants.dart';

class SocketService {
  final SecureStorageService _secureStorageService;
  io.Socket? _socket;
  bool _isConnected = false;

  final StreamController<bool> _connectionStateController = StreamController<bool>.broadcast();
  final StreamController<Map<String, dynamic>> _newMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _conversationUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _messagesReadController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _errorController = StreamController<Map<String, dynamic>>.broadcast();

  SocketService(this._secureStorageService);

  bool get isConnected => _isConnected;
  Stream<bool> get connectionStateStream => _connectionStateController.stream;
  Stream<Map<String, dynamic>> get newMessageStream => _newMessageController.stream;
  Stream<Map<String, dynamic>> get conversationUpdatedStream => _conversationUpdatedController.stream;
  Stream<Map<String, dynamic>> get messagesReadStream => _messagesReadController.stream;
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;
  Stream<Map<String, dynamic>> get errorStream => _errorController.stream;

  Future<void> initSocket() async {
    if (_socket != null && _isConnected) return;

    final token = await _secureStorageService.read(AppConstants.userTokenKey);
    if (token == null || token.isEmpty) return;

    _disconnectExisting();

    _socket = io.io(
      AppConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setPath(AppConstants.socketPath)
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(2000)
          .setReconnectionAttempts(10)
          .build(),
    );

    _socket?.onConnect((_) {
      _isConnected = true;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(true);
      }
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(false);
      }
    });

    _socket?.onConnectError((err) {
      _isConnected = false;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(false);
      }
    });

    _socket?.on('connection:ready', (data) {
      _isConnected = true;
      if (!_connectionStateController.isClosed) {
        _connectionStateController.add(true);
      }
    });

    _socket?.on('chat:new_message', (data) {
      if (data is Map<String, dynamic> && !_newMessageController.isClosed) {
        _newMessageController.add(data);
      } else if (data is Map && !_newMessageController.isClosed) {
        _newMessageController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('chat:conversation_updated', (data) {
      if (data is Map<String, dynamic> && !_conversationUpdatedController.isClosed) {
        _conversationUpdatedController.add(data);
      } else if (data is Map && !_conversationUpdatedController.isClosed) {
        _conversationUpdatedController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('chat:messages_read', (data) {
      if (data is Map<String, dynamic> && !_messagesReadController.isClosed) {
        _messagesReadController.add(data);
      } else if (data is Map && !_messagesReadController.isClosed) {
        _messagesReadController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('chat:conversation_read', (data) {
      if (data is Map<String, dynamic> && !_messagesReadController.isClosed) {
        _messagesReadController.add(data);
      } else if (data is Map && !_messagesReadController.isClosed) {
        _messagesReadController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('chat:typing', (data) {
      if (data is Map<String, dynamic> && !_typingController.isClosed) {
        _typingController.add(data);
      } else if (data is Map && !_typingController.isClosed) {
        _typingController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('chat:error', (data) {
      if (data is Map<String, dynamic> && !_errorController.isClosed) {
        _errorController.add(data);
      } else if (data is Map && !_errorController.isClosed) {
        _errorController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.connect();
  }

  void startConversation({
    required String groupId,
    required String studentId,
    void Function(dynamic)? onAck,
  }) {
    if (_socket == null) return;
    final payload = {
      'groupId': groupId,
      'studentId': studentId,
    };
    if (onAck != null) {
      _socket?.emitWithAck('chat:start_conversation', payload, ack: onAck);
    } else {
      _socket?.emit('chat:start_conversation', payload);
    }
  }

  void sendMessage({
    required String conversationId,
    required String content,
    String? attachmentUrl,
    String? clientMessageId,
    void Function(dynamic)? onAck,
  }) {
    if (_socket == null) return;
    final payload = <String, dynamic>{
      'conversationId': conversationId,
      'content': content,
    };
    if (attachmentUrl != null) {
      payload['attachmentUrl'] = attachmentUrl;
    }
    if (clientMessageId != null) {
      payload['clientMessageId'] = clientMessageId;
    }
    if (onAck != null) {
      _socket?.emitWithAck('chat:send_message', payload, ack: onAck);
    } else {
      _socket?.emit('chat:send_message', payload);
    }
  }

  void markRead({required String conversationId}) {
    if (_socket == null) return;
    _socket?.emit('chat:mark_read', {
      'conversationId': conversationId,
    });
  }

  void sendTyping({required String conversationId, required bool isTyping}) {
    if (_socket == null) return;
    _socket?.emit('chat:typing', {
      'conversationId': conversationId,
      'isTyping': isTyping,
    });
  }

  void _disconnectExisting() {
    _socket?.clearListeners();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  void disconnect() {
    _disconnectExisting();
  }

  void dispose() {
    disconnect();
    _connectionStateController.close();
    _newMessageController.close();
    _conversationUpdatedController.close();
    _messagesReadController.close();
    _typingController.close();
    _errorController.close();
  }
}
