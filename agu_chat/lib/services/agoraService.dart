import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/agora_token.dart';
import '../models/responseData.dart';
import '../utils/const.dart';
import '../utils/global.dart';

class AgoraService{
  Future<ResponseData<AgoraToken>> getRtcToken() async{
    final res = ResponseData<AgoraToken>();
    try {
      Map<String, String> param = <String, String>{};
      param["uid"] = Global.user!.username;
      param["channelName"] = Global.channelName!;// channel nhan tu presence Hub

      final uri = Uri.parse('$urlBase/api/agora/get-rtc-token');

      var response = await http.post(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      }, body: jsonEncode(param));

      if (response.statusCode == 200) {
        res.message = '200';
        final token = AgoraToken.fromJson(jsonDecode(response.body));
        print("agora token: ${token.token}");
        res.data = token;
      } else {
        res.message = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      res.message = e.toString();
    }
    return res;
  }
}