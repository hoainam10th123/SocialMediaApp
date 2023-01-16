class ImageOfPost{
  final int id;
  final String path;

  ImageOfPost({required this.id, required this.path});

  factory ImageOfPost.fromJson(Map<String, dynamic> json) {
    return ImageOfPost(
        id: json['id'],
        path: json['path']
    );
  }
}