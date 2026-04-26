import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/bps_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pesan sambutan awal
    _messages.addAll([
      {
        "role": "bot",
        "time": _getCurrentTime(),
        "content":
            "Halo! Saya adalah asisten virtual BPS Kudus. Saya bisa membantu menjawab pertanyaan umum seputar layanan kami. 👋"
      },
      {
        "role": "bot",
        "time": _getCurrentTime(),
        "content":
            "Untuk permintaan data statistik spesifik, silakan hubungi tim kami melalui tombol di bawah ini."
      },
    ]);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({
        "role": "user",
        "time": _getCurrentTime(),
        "content": text,
      });
      _isLoading = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      const systemPrompt = '''
      Anda adalah asisten virtual resmi BPS Kabupaten Kudus.
      Tugas Anda: Menjawab pertanyaan umum (alamat, jam buka, prosedur layanan).
      DILARANG: Memberikan angka data statistik secara langsung.
      PENGARAHAN: Jika pengguna meminta data, arahkan ke WA: 08159553319 atau Email: bps3319@bps.go.id.
      ''';

      final recentMessages = _messages.length > 10
          ? _messages.sublist(_messages.length - 10)
          : _messages;
      final apiMessages = recentMessages
          .map((m) => {
                "role": m["role"] == "bot" ? "assistant" : "user",
                "content": m["content"] as String
              })
          .toList();

      final response = await BpsService.getChatbotResponse(
          systemPrompt: systemPrompt, messages: apiMessages);

      setState(() {
        _messages.add(
            {"role": "bot", "time": _getCurrentTime(), "content": response});
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "bot",
          "time": _getCurrentTime(),
          "content":
              "Maaf, sistem sedang sibuk. Silakan hubungi kami via WhatsApp."
        });
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Gagal membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Column(
          children: [
            Text("● Admin Layanan",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text("BPS KABUPATEN KUDUS",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopButton("WhatsApp", Icons.chat, Colors.green,
                  "https://wa.me/628159553319"),
              const SizedBox(width: 15),
              _buildTopButton("Email", Icons.email, Colors.orange,
                  "mailto:bps3319@bps.go.id"),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(
                    msg["content"], msg["role"] == "user", msg["time"]);
              },
            ),
          ),
          if (_isLoading) _buildLoadingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTopButton(String label, IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUser)
            const Text("  Admin Layanan",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? Colors.orange : const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: Radius.circular(isUser ? 15 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 15),
              ),
            ),
            child: Text(text,
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 13.5)),
          ),
          Text(" $time",
              style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.orange)),
          SizedBox(width: 10),
          Text("Admin sedang mengetik...",
              style: TextStyle(fontSize: 11, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Tanya layanan BPS...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none),
                fillColor: const Color(0xFFF5F5F5),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.send, size: 18, color: Colors.white),
          )
        ],
      ),
    );
  }
}
