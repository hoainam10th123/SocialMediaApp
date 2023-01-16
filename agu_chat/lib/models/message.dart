class Message{
  int? id;
  String? senderId;
  String? senderUsername;
  String? senderPhotoUrl;
  String? senderDisplayName;
  String? recipientId;
  String? recipientUsername;
  String? recipientPhotoUrl;
  String? recipientDisplayName;
  String? content;
  DateTime? dateRead;
  DateTime? messageSent;

  Message(
      {this.id,
        this.senderId,
        this.senderUsername,
        this.senderPhotoUrl,
        this.senderDisplayName,
        this.recipientId,
        this.recipientUsername,
        this.recipientPhotoUrl,
        this.recipientDisplayName,
        this.content,
        this.dateRead,
        this.messageSent
});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
      senderId: json['senderId'],
      senderUsername: json['senderUsername'],
      senderPhotoUrl: json['senderPhotoUrl'],
      senderDisplayName: json['senderDisplayName'],
      recipientId: json['recipientId'],
      recipientUsername: json['recipientUsername'],
      recipientPhotoUrl: json['recipientPhotoUrl'],
      recipientDisplayName: json['recipientDisplayName'],
      content: json['content'],
      dateRead: json['dateRead'] == null ? DateTime.now() : DateTime.parse(json['dateRead']),
      messageSent: DateTime.parse(json['messageSent']),
    );
  }
}