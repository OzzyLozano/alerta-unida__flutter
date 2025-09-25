import 'dart:convert';
import 'package:app_test/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatScreen extends StatefulWidget {
  final int alertId;

  const ChatScreen({super.key, required this.alertId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<Map<String, dynamic>>> _futureMessages;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  late PusherChannelsFlutter pusher;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _futureMessages = fetchMessages("${AppConfig.apiUrl}/api/alerts/${widget.alertId}/chat");
    _getCurrentUserId().then((_) {
      _initializePusher();
    });
  }

  Future<void> _getCurrentUserId() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = (preferences.getInt('userId') ?? 0).toString();
    });
  }

  void _initializePusher() async {
    try {
      pusher = PusherChannelsFlutter.getInstance();
      
      await pusher.init(
        apiKey: AppConfig.pusherApiKey,
        cluster: AppConfig.pusherCluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
      );
      
      await pusher.subscribe(channelName: 'chat.alert.${widget.alertId}');
      await pusher.connect();
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing Pusher: $e");
      }
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (kDebugMode) {
      print("Connection: $currentState");
    }
  }

  dynamic onError(String message, int? code, dynamic e) {
    if (kDebugMode) {
      print("Error: $message, code: $code, exception: $e");
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    if (kDebugMode) {
      print("Subscribed to $channelName");
    }
  }

  void onEvent(PusherEvent event) {
    if (kDebugMode) {
      print("🎯🎯🎯 RAW EVENT: '${event.eventName}'");
      print("🎯🎯🎯 RAW DATA: '${event.data}'");
      print("🎯🎯🎯 CHANNEL: '${event.channelName}'");
      print("🎯🎯🎯 TIMESTAMP: ${DateTime.now()}");
      print("----------------------------------------");
    }

    if (event.eventName == 'App\\Events\\NewChatMessage' || 
        event.eventName == 'NewChatMessage') {
      try {
        final messageData = json.decode(event.data!);
        _addMessage(messageData);
      } catch (e) {
        if (kDebugMode) {
          print("❌ Error parsing message: $e");
        }
      }
    }
  }

  void onSubscriptionError(String message, dynamic e) {
    if (kDebugMode) {
      print("Subscription error: $message, exception: $e");
    }
  }

  void onDecryptionFailure(String event, String reason) {
    if (kDebugMode) {
      print("Decryption failure: $event, reason: $reason");
    }
  }

  void onMemberAdded(String channelName, dynamic member) {
    if (kDebugMode) {
      print("Member added to $channelName: $member");
    }
  }

  void onMemberRemoved(String channelName, dynamic member) {
    if (kDebugMode) {
      print("Member removed from $channelName: $member");
    }
  }

  void _addMessage(Map<String, dynamic> messageData) {
    final isMe = messageData['brigade_id'].toString() == _currentUserId;
    
    setState(() {
      messages.add({
        "sender": isMe ? "Tú" : messageData['brigade_name'],
        "text": messageData['message'],
        "isMe": isMe,
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String apiUrl) async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> msgs = data["messages"];
      
      final preferences = await SharedPreferences.getInstance();
      final int userId = preferences.getInt('userId') ?? 0;

      return msgs.map((msg) {
        final isMe = msg["brigade_id"] == userId;
        return {
          "sender": isMe ? "Tú" : msg["brigade_name"],
          "text": msg["message"] ?? "",
          "isMe": isMe,
        };
      }).toList();
    } else {
      throw Exception("Error al cargar mensajes");
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt("userId");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró el usuario logueado")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("${AppConfig.apiUrl}/api/messages/send/$userId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "alert_id": widget.alertId,
        "message": _controller.text,
      }),
    );

    if (response.statusCode == 200) {
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar el mensaje")),
      );
      if (kDebugMode) {
        print("error: ${response.statusCode}\n ${response.body}");
      }
    }
  }

  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }
  /// --- Menú de 3 puntos ---
  void _onMenuSelected(String value) {
    switch (value) {
      case 'detalles':
        _showDetailsDialog();
        break;
      case 'participantes':
        _showParticipantsDialog();
        break;
      case 'personalizacion':
        _showCustomizationDialog();
        break;
    }
  }

  void _showDetailsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Detalles de la alerta"),
        content: const Text(
            "Aquí puedes mostrar los datos de la alerta (tipo, ubicación, hora, etc.)."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        ],
      ),
    );
  }

  void _showParticipantsDialog() {
    final uniqueUsers = messages
        .where((m) => m["sender"] != "Tú")
        .map((m) => m["sender"])
        .toSet()
        .toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Participantes"),
        content: uniqueUsers.isEmpty
            ? const Text("Aún no hay otros participantes.")
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: uniqueUsers.map((u) => ListTile(title: Text(u))).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        ],
      ),
    );
  }

  void _showCustomizationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Personalización"),
        content: const Text("Aquí podrías permitir cambiar tema o tamaño de letra."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Chat Alerta ${widget.alertId}"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'detalles', child: Text('Detalles de la alerta')),
              PopupMenuItem(value: 'participantes', child: Text('Participantes')),
              PopupMenuItem(value: 'personalizacion', child: Text('Personalización')),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _futureMessages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            if (messages.isEmpty) messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg["isMe"];
                      return Align(
                        alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[600] : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    msg["sender"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              Text(
                                msg["text"],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Escribe un mensaje...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
