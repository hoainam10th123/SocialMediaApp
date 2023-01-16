import 'dart:convert';
import 'dart:io';

import 'package:agu_chat/models/last_message_chat.dart';
import 'package:agu_chat/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/const.dart';

class LastMessageChatController extends GetxController {
  var lastMessages = <LastMessageChat>[].obs;
  var isLoading = false.obs;

  Future<String> fetchLastMessages() async{
    String messageRes = '';
    try {
      isLoading.value = true;
      final uri = Uri.parse('$urlBase/api/LastMessageChats?pageNumber=1&pageSize=5');

      var response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        lastMessages.value = list.map<LastMessageChat>((json) => LastMessageChat.fromJson(json)).toList();
        messageRes = '200';
        isLoading.value = false;
      } else {
        messageRes = '${response.statusCode} ${response.body}';
        isLoading.value = false;
      }
    } catch (e) {
      messageRes = e.toString();
      isLoading.value = false;
    }
    return messageRes;
  }
}