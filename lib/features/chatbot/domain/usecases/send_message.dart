import 'package:e_commerce/Features/chatbot/domain/entitys/message_entity.dart';

class SendMessage {
  Future<MessageEntity> call(String text) async {
    return MessageEntity(
      "⚠️ يرجى استشارة طبيب مختص\nPlease consult a doctor",
      false,
    );
  }
}
