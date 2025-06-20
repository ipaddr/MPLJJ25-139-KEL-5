import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Definisi kelas Message untuk menyimpan data pesan
class Message {
  final String text;
  final bool isUser; // true jika pesan dari pengguna, false jika dari bot
  final DateTime createdAt;

  Message({
    required this.text,
    required this.isUser,
    required this.createdAt,
  });
}

// UBAH NAMA KELAS DARI ChatBotScreen MENJADI ChatbotPage
class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key}); // UBAH KONSTRUKTOR

  @override
  State<ChatbotPage> createState() => _ChatbotPageState(); // UBAH createState
}

// UBAH NAMA KELAS STATE DARI _ChatBotScreenState MENJADI _ChatbotPageState
class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [];

  late final GenerativeModel _model;
  late final ChatSession _chat;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey:
          'AIzaSyCczypulZKnwl6MAI3x87nIb18BRuyBG0U', // Ganti dengan API key-mu
    );
    _chat = _model.startChat();

    _addMessage(
      Message(
        text:
            "Halo! Saya adalah Chatbot BentoBuddy. Ada yang bisa saya bantu terkait bantuan bento?",
        isUser: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(Message message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    _addMessage(Message(text: input, isUser: true, createdAt: DateTime.now()));
    _controller.clear();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(input));
      final output =
          response.text ?? 'Tidak ada balasan yang valid dari Gemini.';

      _addMessage(
          Message(text: output, isUser: false, createdAt: DateTime.now()));
    } catch (e) {
      print('Error calling Gemini: $e');
      _addMessage(Message(
          text: 'Maaf, terjadi kesalahan: $e',
          isUser: false,
          createdAt: DateTime.now()));
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BentoBOT'),
        backgroundColor: const Color(0xFF1E2378),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bentobot sedang mengetik...',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ),
            ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final alignment =
        message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color =
        message.isUser ? const Color(0xFFE0E0E0) : const Color(0xFF1E2378);
    final textColor = message.isUser ? Colors.black : Colors.white;
    final borderRadius = BorderRadius.circular(12);

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _isLoading ? null : _sendMessage,
            mini: true,
            backgroundColor: const Color(0xFF1E2378),
            foregroundColor: Colors.white,
            elevation: 0,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
