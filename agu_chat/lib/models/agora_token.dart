class AgoraToken{
  String token;

  AgoraToken({required this.token});

  factory AgoraToken.fromJson(Map<String, dynamic> json) {
    return AgoraToken(
        token: json['token']
    );
  }
}