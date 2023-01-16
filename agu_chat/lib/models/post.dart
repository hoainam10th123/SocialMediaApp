import 'package:agu_chat/models/comment.dart';

import 'imageOfPost.dart';

class Post{
  final int id;
  String? noiDung;
  final DateTime created;
  final String userName;
  final String displayName;
  String? imageUrl;
  final List<Comment> comments;
  final List<ImageOfPost> images;
  final int category;

  Post({required this.id,
    this.noiDung,
    required this.created,
    required this.userName,
    required this.displayName,
    this.imageUrl,
    required this.comments,
    required this.images,
    required this.category
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        noiDung: json['noiDung'],
      created: DateTime.parse(json['created']),
      userName: json['userName'],
      displayName: json['displayName'],
      imageUrl: json["imageUrl"],
      category:  json["category"],
      comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
      images: List<ImageOfPost>.from(json["images"].map((x) => ImageOfPost.fromJson(x))),
    );
  }

  static Post fromJsonModel(Map<String, dynamic> json) => Post.fromJson(json);
}