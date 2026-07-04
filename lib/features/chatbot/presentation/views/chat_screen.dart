import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/Features/chatbot/domain/entitys/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().send(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FAFC),
        appBar: AppBar(
          title: const Text(
            'PharmaGo AI',
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppColors.darkBlue),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatLoaded) {
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    if (state is! ChatLoaded) {
                      return const SizedBox.shrink();
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount:
                          state.messages.length + (state.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const _TypingBubble();
                        }

                        return _MessageBubble(message: state.messages[index]);
                      },
                    );
                  },
                ),
              ),
              _SafetyStrip(),
              _ChatInput(controller: _controller, onSend: _sendMessage),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
            border: isUser ? null : Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            message.text,
            textDirection: _hasArabic(message.text)
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(
              color: isUser ? AppColors.white : AppColors.darkGray,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  bool _hasArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Text(
          'جاري البحث عن اقتراحات مناسبة...',
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SafetyStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.14)),
      ),
      child: const Text(
        "⚠️ تنويه طبي: هذا المساعد يقدم معلومات عامة وإرشادية فقط ولا يغني عن استشارة الطبيب أو الصيدلي. إذا كنت تعاني من أي حساسية، أو موانع استخدام لمواد فعالة معينة، أو لديك مشاكل صحية مزمنة (مثل مرضى الكبد والكلى الذين تتطلب حالتهم حذراً خاصاً مع مواد كالباراسيتامول أو الكافيين)، أو أي حالة خطيرة أخرى، يرجى استشارة طبيب مختص فوراً قبل أخذ أي علاج. الإجابات المقدمة هنا هي إجابات عامة ومبنية على افتراض سلامتك التامة وعدم معاناتك من أي عارض صحي آخر غير الذي قمت بوصفه بدقة.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'اكتب العرض هنا...',
                filled: true,
                fillColor: const Color(0xFFF5F8FA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            width: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                tooltip: 'إرسال',
                onPressed: onSend,
                icon: const Icon(
                  Icons.send_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
