import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> messages = [];
  final String backendUrl = 'http://localhost:8080/chat';

  bool bookingCompleted = false;

  Future<void> sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add(_ChatMessage(text: userInput, isUser: true));
      _controller.clear();
    });

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: '"$userInput"',
    );

    if (response.statusCode == 200) {
      final responseText = response.body;
      setState(() {
        messages.add(_ChatMessage(text: responseText, isUser: false));
        if (responseText.contains("✅ Booking complete")) {
          bookingCompleted = true;
        }
      });
    } else {
      setState(() {
        messages.add(
          _ChatMessage(
            text: '❌ Error communicating with chatbot.',
            isUser: false,
          ),
        );
      });
    }
  }

  Future<void> downloadTicket() async {
    final url = Uri.parse('$backendUrl/download-ticket');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // In real app: save PDF using path_provider and open_file packages
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "🎫 Ticket download successful (not saved in this demo).",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to download ticket.")),
      );
    }
  }

  Future<void> resetChat() async {
    final url = Uri.parse('$backendUrl/reset');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      setState(() {
        messages.clear();
        bookingCompleted = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    messages.add(
      _ChatMessage(
        text: "👋 Hi! I'm AirVista Assistant.\nLet's book your flight.",
        isUser: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✈️ AirVista Chatbot"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: resetChat),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text, style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          if (bookingCompleted)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: downloadTicket,
                icon: const Icon(Icons.download),
                label: const Text("Download Ticket"),
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => sendMessage(),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
