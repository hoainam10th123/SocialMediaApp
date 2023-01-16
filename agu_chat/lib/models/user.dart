class User {
  String id;
  String username;
  String token;
  String displayName;
  String? imageUrl;

  User(
      {required this.id, required this.username, required this.token, required this.displayName, this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        token: json['token'],
        displayName: json['displayName'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'username': username,
        'token': token,
        'displayName': displayName,
        'imageUrl': imageUrl,
      };
}