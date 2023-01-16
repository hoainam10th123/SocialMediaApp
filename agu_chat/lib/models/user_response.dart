import 'package:agu_chat/models/user.dart';

class UserResponse {
  User? user;
  String? error;

  UserResponse();
  UserResponse.mock(this.user): error = "";
}