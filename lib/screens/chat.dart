import 'dart:convert';
import 'package:app_test/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final int alertId;

  const ChatScreen({Key? key, required this.alertId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<Map<String, dynamic>>> _futureMessages;
  final TextEditingController _controller = TextEditingController();
  
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _futureMessages = fetchMessages("${AppConfig.apiUrl}/api/alerts/${widget.alertId}/chat");
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
        return {
          "sender": (msg["brigade_id"] == userId) ? "Tú" : msg["brigade_name"],
          "text": msg["message"] ?? "",
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
      setState(() {
        messages.add({"sender": "Tú", "text": _controller.text});
      });
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al enviar el mensaje")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Alerta ${widget.alertId}"),
      ),
      body: FutureBuilder(
        future: _futureMessages, 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error has occurred: ${snapshot.error}', 
                style: const TextStyle(fontSize: 20),
              ),
            );
          } else if (snapshot.hasData) {
            messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg["sender"] == "Tú";

                      return Column(
                        children: [
                          Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                msg["text"],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.grey[200],
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}
