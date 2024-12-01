import 'package:scp/model/chat_room_model.dart';

class ChatModel {
  final String? id;
  final String message;
  final ChatRoomModel? chatRooms;
  final String userId;
  final String? createdAt;

  const ChatModel({
    this.id,
    required this.message,
    this.chatRooms,
    required this.userId,
    this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      message: json['message'],
      chatRooms: json['chat_rooms'] != null
          ? ChatRoomModel.fromJson(json['chat_rooms'])
          : null,
      userId: json['user_id'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'chat_rooms': chatRooms,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      message: map['message'],
      chatRooms: map['chat_rooms'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }
}
