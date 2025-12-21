import 'package:e_commerce/core/models/message_model.dart';
import 'package:e_commerce/core/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/paragraph.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

class ChatbootBody extends StatefulWidget {
  const ChatbootBody({super.key});

  @override
  State<ChatbootBody> createState() => _ChatbootBodyState();
}

class _ChatbootBodyState extends State<ChatbootBody> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  final AiService _aiService = AiService();
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _messages.add(
      Message(
        text: "Hello! Im here to help . How can I assist you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(text: text, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    try {
      final response = await _aiService.sendMessage(text);
      setState(() {
        _messages.add(
          Message(text: response, isUser: false, timestamp: DateTime.now()),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            text:
                "I apolifize, but Im Currently unable to process your request. please try again",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Chatbot",
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'OnLine',
                  style: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Color(0xFF6B7280)),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  Message(
                    text:
                        "Hello! Im here to help . How can I assist you today?",
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_isLoading) _buildTypingIndicator(),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,

                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 16,
                          ),

                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          border: InputBorder.none,
                          // border: OutlineInputBorder(
                          // borderRadius: BorderRadius.circular(24),
                          // borderSide: BorderSide.none,
                          //),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_textController.text),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,

        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser ? Color(0xFF2563EB) : Color(0xFFF3F4F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 0),
                  bottomRight: Radius.circular(message.isUser ? 16 : 0),
                ),
              ),
              child: MarkdownBlock(
                data: message.text,
                config: MarkdownConfig(
                  configs: [
                    PConfig(
                      textStyle: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (message.isUser) ...{
            SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFF6B7280),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          },
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F6),

              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                SizedBox(width: 4),
                _buildTypingDot(1),
                SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: (_animationController.value + index * 0.2) % 1.0,
          child: child,
        );
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: Color(0xFF9CA3AF),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}




