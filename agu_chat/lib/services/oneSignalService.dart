import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/const.dart';
import '../utils/global.dart';

class OneSignalService{
  OneSignalService();

  Future<String> postPlayerId(String? id) async{
    String messageRes = '';
    try {
      final uri = Uri.parse('$urlBase/api/OneSignal/post-player-id/$id');

      var response = await http.post(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 204) {
        messageRes = '200';
      } else {
        messageRes = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      messageRes = e.toString();
    }
    return messageRes;
  }
}