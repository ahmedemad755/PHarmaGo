import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';

class ChatRepoImpl {
  Future<MessageEntity> fallback() async {
    return MessageEntity("⚠️ No exact match, please consult a doctor", false);
  }
}
