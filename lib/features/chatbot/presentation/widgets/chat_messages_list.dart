import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'message_bubble.dart';
import 'chat_helper_widgets.dart';

class ChatMessagesList extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback scrollToBottom;

  const ChatMessagesList({
    super.key,
    required this.scrollController,
    required this.scrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state is! ChatLoaded) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          itemCount: state.messages.length + (state.isTyping ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.messages.length) {
              return const TypingBubble();
            }

            return MessageBubble(message: state.messages[index]);
          },
        );
      },
    );
  }
}