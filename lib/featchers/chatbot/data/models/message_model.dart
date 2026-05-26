import 'package:e_commerce/featchers/chatbot/domain/entitys/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({required String text, required bool isUser}) : super(text, isUser);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
    };
  }
}