class ChatRoomModel {
  final String? id;
  final String lastMessage;
  final String? createdAt;
  final String? updatedAt;
  final String? buyerId;
  final String? consultantId;

  const ChatRoomModel({
    this.id,
    required this.lastMessage,
    this.createdAt,
    this.updatedAt,
    this.buyerId,
    this.consultantId,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      lastMessage: json['last_message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      buyerId: json['buyer_id'],
      consultantId: json['consultant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'buyer_id': buyerId,
      'consultant_id': consultantId,
    };
  }
}
