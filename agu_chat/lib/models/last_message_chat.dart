class LastMessageChat {
  String id;
  String senderId;
  String senderUsername;
  String recipientId;
  String recipientUsername;
  String content;
  DateTime messageLastDate;
  String groupName;
  bool isRead;
  int unreadCount = 0;
  String senderDisplayName;
  String? senderImgUrl;// fix error type NULL not sub type of String, because senderImgUrl can return null

  LastMessageChat(
      {required this.id,
      required this.senderId,
      required this.senderUsername,
      required this.recipientId,
      required this.recipientUsername,
      required this.content,
      required this.messageLastDate,
      required this.groupName,
      required this.isRead,
        required this.unreadCount,
        required this.senderDisplayName,
        required this.senderImgUrl
      });

  factory LastMessageChat.fromJson(Map<String, dynamic> json) {
    return LastMessageChat(
        id: json['id'],
      senderId: json['senderId'],
      senderUsername: json['senderUsername'],
      recipientId: json['recipientId'],
      recipientUsername: json['recipientUsername'],
      content: json['content'],
      messageLastDate: DateTime.parse(json['messageLastDate']),
      groupName: json['groupName'],
      isRead: json['isRead'],
      unreadCount: 0,
        senderDisplayName: json['senderDisplayName'],
      senderImgUrl: json['senderImgUrl'],
    );
  }
}
