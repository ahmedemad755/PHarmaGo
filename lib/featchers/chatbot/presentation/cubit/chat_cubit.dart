import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';
import 'package:e_commerce/featchers/chatbot/domain/usecases/send_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessage sendMessageUseCase; // التعديل هنا

  ChatCubit(this.sendMessageUseCase)
      : super(ChatLoaded(messages: List.unmodifiable(_initialMessages)));

  static final List<MessageEntity> _initialMessages = [
    MessageEntity(
      'أهلاً بك في PharmaGo AI.\nاكتب العرض الذي تشعر به مثل: عندي صداع، I have fever، أو عندي برد.',
      false,
    ),
  ];

  final List<MessageEntity> _messages = List.of(_initialMessages);

  Future<void> send(String text) async {
    final message = text.trim();
    if (message.isEmpty) return;

    _addMessage(MessageEntity(message, true), isTyping: true);

    try {
      // استدعاء الـ UseCase مباشرة وهو يتكفل بالباقي
      final responseEntity = await sendMessageUseCase(message);
      _addBotMessage(responseEntity.text);
    } catch (_) {
      _addBotMessage('حدث خطأ أثناء معالجة الطلب، يرجى المحاولة مرة أخرى.');
    }
  }

  void _addMessage(MessageEntity message, {bool isTyping = false}) {
    _messages.add(message);
    _emitLoaded(isTyping: isTyping);
  }

  void _addBotMessage(String text) {
    _messages.add(MessageEntity(text, false));
    _emitLoaded();
  }

  void _emitLoaded({bool isTyping = false}) {
    emit(
      ChatLoaded(
        messages: List.unmodifiable(_messages),
        isTyping: isTyping,
      ),
    );
  }
}