class Comment{
  int id;
  String noiDung;
  DateTime created;
  int postId;
  String displayName;
  String? userImageUrl;

  Comment({
    required this.id,
    required this.noiDung,
    required this.created,
    required this.postId,
    required this.displayName,
    required this.userImageUrl
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      noiDung: json['noiDung'],
        created: DateTime.parse(json['created']),
      postId: json['postId'],
        displayName: json['displayName'],
        userImageUrl: json['userImageUrl'],
    );
  }

  static Comment fromJsonModel(Map<String, dynamic> json) => Comment.fromJson(json);
}