import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonChatPage extends StatefulWidget {
  const PersonChatPage({super.key, required this.personName});

  final String personName;

  @override
  State<PersonChatPage> createState() => _PersonChatPageState();
}

class _PersonChatPageState extends State<PersonChatPage> {
  final List<_ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSending = false;

  static const _apiKey = 'f9184972fcca4b8ea562010abce353c6.UPLKPeEj45P66e9e';

  @override
  void initState() {
    super.initState();
    _messages.add(
      _ChatMessage(
        role: 'assistant',
        content:
            "Hey there! I'm ${widget.personName}. What kind of training tips are you looking for today?",
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
      _controller.clear();
      _isSending = true;
    });
    try {
      final reply = await _callAi(text);
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: reply));
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(
            role: 'assistant',
            content:
                "Sorry, I couldn't respond right now. Please try again later.",
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<String> _callAi(String prompt) async {
    final url = Uri.parse(
      'https://open.bigmodel.cn/api/paas/v4/chat/completions',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        'model': 'GLM-4-Flash',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are ${widget.personName}, a friendly fitness enthusiast who replies in short English sentences.',
          },
          for (final message in _messages)
            {'role': message.role, 'content': message.content},
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices != null && choices.isNotEmpty) {
        final message = choices.first['message'] as Map<String, dynamic>?;
        final content = message?['content'];
        if (content is String && content.isNotEmpty) {
          return content;
        }
      }
    }
    throw Exception('AI request failed');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('${widget.personName} Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.role == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color(0xFF28FF5E)
                            : const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isUser ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1, color: Color(0xFF1C1C1E)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: Color(0xFF999999)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF28FF5E),
                            ),
                          )
                        : const Icon(Icons.send, color: Color(0xFF28FF5E)),
                    onPressed: _isSending ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.role, required this.content});

  final String role;
  final String content;
}
