import 'package:scp/model/chat_room_model.dart';

class ChatModel {
  final String? id;
  final String message;
  final ChatRoomModel? chatRooms;
  final String? updatedAt;

  const ChatModel({
    this.id,
    required this.message,
    this.chatRooms,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      chatRooms: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'created_at': chatRooms,
      'updated_at': updatedAt,
    };
  }
}
