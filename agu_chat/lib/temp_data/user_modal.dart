import 'package:agu_chat/temp_data/post_model.dart';

class UserTemp {
  final String profileImageUrl;
  final String backgroundImageUrl;
  final String name;
  final int following;
  final int followers;
  final List<PostTemp> posts;
  final List<PostTemp> favorites;

  UserTemp({
    required this.profileImageUrl,
    required this.backgroundImageUrl,
    required this.name,
    required this.following,
    required this.followers,
    required this.posts,
    required this.favorites,
  });
}