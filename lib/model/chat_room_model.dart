class ChatRoomModel {
  final String? id;
  final String lastMessage;
  final String? createdAt;
  final String? updatedAt;

  const ChatRoomModel({
    this.id,
    required this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      lastMessage: json['last_message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
