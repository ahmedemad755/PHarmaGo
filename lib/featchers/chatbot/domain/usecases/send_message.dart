import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';
import 'package:e_commerce/featchers/chatbot/domain/repos/chat_repo.dart';

class SendMessage {
  final ChatRepo repository;

  SendMessage(this.repository);

  Future<MessageEntity> call(String text) async {
    return await repository.sendMessage(text);
  }
}