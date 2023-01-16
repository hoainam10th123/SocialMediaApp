import 'dart:convert';
import 'package:agu_chat/models/user.dart';
import 'package:agu_chat/models/user_response.dart';
import '../utils/const.dart';
import 'package:http/http.dart' as http;

class AuthASP {
  AuthASP();

  Future<UserResponse> signIn(String userName, String password) async {
    UserResponse resp = UserResponse();

    Map<String, String> param = <String, String>{};
    param["Username"] = userName;
    param["Password"] = password;

    try {
      final url = Uri.parse('$urlBase/api/Account/login');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(param));

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        resp.error = '200';
        resp.user = user;
      } else {
        resp.error = '${response.statusCode} ${response.body}';
        return resp;
      }
    } catch (e) {
      print(e);
      resp.error = e.toString();
    }
    return resp;
  }
}