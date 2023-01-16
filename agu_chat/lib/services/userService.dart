import 'dart:convert';
import 'dart:io';

import '../models/member.dart';
import '../models/responseData.dart';
import '../utils/const.dart';
import 'package:http/http.dart' as http;

import '../utils/global.dart';

class UserService{
  UserService();

  Future<ResponseData<Member>> getMember(String username) async{
    final dataRes = ResponseData<Member>();
    try {
      final uri = Uri.parse('$urlBase/api/User/$username');

      var response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        dataRes.message = '200';
        final member = Member.fromJson(jsonDecode(response.body));
        dataRes.data = member;
      } else {
        dataRes.message = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      dataRes.message = e.toString();
    }
    return dataRes;
  }
}