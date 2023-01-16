class Member {
  String? userName;
  String? displayName;
  DateTime? lastActive;
  String? photoUrl;
  int unReadMessageCount;
  bool isOnline = false;

  Member(
      {this.userName,
        this.displayName,
        this.lastActive,
        this.photoUrl,
        required this.unReadMessageCount});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        userName: json['userName'],
        displayName: json['displayName'],
        lastActive: DateTime.parse(json['lastActive']),
        photoUrl: json['imageUrl'],
        unReadMessageCount: json['unReadMessageCount']);
  }
}