import 'package:e_commerce/Features/chatbot/domain/entitys/message_entity.dart';

abstract class ChatRepo {
  Future<MessageEntity> sendMessage(String message);
}
