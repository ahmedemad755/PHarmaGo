import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;
  final bool isTyping;

  ChatLoaded({required this.messages, this.isTyping = false});
}
