import 'package:agu_chat/temp_data/user_modal.dart';

class PostTemp {
  final String imageUrl;
  final UserTemp author;
  final String title;
  final String location;
  final int likes;
  final int comments;

  PostTemp({
    required this.imageUrl,
    required this.author,
    required this.title,
    required this.location,
    required this.likes,
    required this.comments,
  });
}

class PostTemp2 {
  final String title;
  final String body;
  PostTemp2(this.title, this.body);
}