import 'dart:convert';
import 'dart:io';

import 'package:agu_chat/models/comment.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:get/get.dart';
import '../models/last_message_chat.dart';
import '../models/member.dart';
import '../models/user.dart';
import '../utils/const.dart';
import '../utils/global.dart';
import 'messageHub.dart';
import 'package:http/http.dart' as http;


class PresenceHubController extends GetxController {
  var users = <Member>[].obs;
  var userSelected = Member(unReadMessageCount: 0).obs;
  final messagesController = Get.put(MessagesHubController());
  var lastMessages = <LastMessageChat>[].obs;
  var isLoading = false.obs;
  HubConnection? _hubConnection;

  void createHubConnection(User? user) {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl("${hubUrl}presence",
          options: HttpConnectionOptions(
              accessTokenFactory: () async => user!.token))
          .build();

      _hubConnection!.onclose(({Exception? error}) => _myFunction(error));

      if (_hubConnection!.state != HubConnectionState.Connected) {
        _hubConnection!.start()?.catchError(
                (e) => {print("PresenceService at Start: $e")});
      }

      _hubConnection!.on("UserIsOnline", _userIsOnline);
      _hubConnection!.on("UserIsOffline", _userIsOffline);
      _hubConnection!.on("GetOnlineUsers", _getOnlineUsers);
      _hubConnection!.on("NewMessageReceived", _newMessageReceived);
      _hubConnection!.on("DisplayInformationCaller", _displayInformationCallerReceived);
      _hubConnection!.on("BroadcastComment", _broadcastCommentReceived);
    }
  }

  _myFunction(Exception? error) => print(error.toString());

  void _broadcastCommentReceived(List<Object?>? parameters) {
    final json = parameters![0] as Map<String, dynamic>;
    final comment = Comment.fromJson(json);
    Global.myStream!.sendComment(comment);
  }

  void _displayInformationCallerReceived(List<Object?>? parameters) {
    //neu app trong background thi khong show cuoc goi den, xu ly trong background mode duoi native
    if(Global.myStream!.isInForeground){
      final memberCallingJson = parameters![0] as Map<String, dynamic>;
      final channelName = parameters[1] as String;
      final memberCalling = Member.fromJson(memberCallingJson);
      Global.channelName = channelName;
      Global.myStream!.navigateToScreen(memberCalling);// listen at bottom_navbar
    }
  }

  void _userIsOnline(List<Object?>? parameters) {
    final memberServer = parameters![0] as Map<String, dynamic>;
    final member = Member.fromJson(memberServer);
    users.add(member);
  }

  void _userIsOffline(List<Object?>? parameters) {
    final String username = parameters![0].toString();
    for (var user in users) {
      if (user.userName == username) {
        users.remove(user);
        break;
      }
    }
  }

  void _getOnlineUsers(List<Object?>? parameters) {
    final memberServer = parameters![0] as List<dynamic>;
    /*users.clear();
    for (var element in memberServer) {
      final mem = Member.fromJson(element);
      users.add(mem);
    }*/
    final listMember = memberServer.map<Member>((json) => Member.fromJson(json)).toList();
    users.value = listMember;
  }

  void _newMessageReceived(List<Object?>? parameters) {
    final memberServer = parameters![0] as Map<String, dynamic>;
    final member = Member.fromJson(memberServer);

    int index = lastMessages.indexWhere(
            (f) => f.senderUsername == member.userName!); //message['senderUsername']
    if (index != -1) {
      lastMessages[index].unreadCount++;
      lastMessages[index] = lastMessages[index];
    }

  }

  void stopHubConnection() {
    _hubConnection!
        .stop()
        .catchError((e) => {print("Presence hub at Stop: $e")});
    _hubConnection = null;
  }

  void clearAll() {
    users.clear();
  }

  void selectedUser(String userName) {
    int index = users.indexWhere((f) => f.userName == userName);
    if (index != -1) {
      users[index].unReadMessageCount = 0;
      userSelected.value = users[index];
      //users[index] = users[index];
    }
  }

  Future<void> callToUser(String ortherUsername, String channelName) async{
    await _hubConnection!.invoke("CallToUsername", args: <Object>[
      ortherUsername, channelName
    ]);
  }

  /*void fetchUsers() async {
    try {
      String authorization = 'Bearer ${Globals.user!.token}';
      final url = Uri.parse("${urlBase}api/User");
      final response = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: authorization});

      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
        users.value =
            parsed.map<Member>((json) => Member.fromJson(json)).toList();
      }
    } catch (e) {
      print(e.toString());
    }
  }*/
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