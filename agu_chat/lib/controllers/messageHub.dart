import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../utils/const.dart';

class MessagesHubController extends GetxController {
  var messages = <Message>[].obs;
  HubConnection? _hubConnection;

  void createHubConnection(User? user, String otherUsername) {
    if (_hubConnection == null) {
      _hubConnection = HubConnectionBuilder()
          .withUrl("${hubUrl}message?user=$otherUsername",
              options: HttpConnectionOptions(
                  accessTokenFactory: () async => user!.token))
          .build();
      _hubConnection!.onclose(({Exception? error}) => print(error.toString()));
      if (_hubConnection!.state != HubConnectionState.Connected) {
        _hubConnection!.start()?.catchError(
            (e) => {debugPrint("Presence hub error at Start: $e")});
        debugPrint("Start hub at Messages Hub: $otherUsername");
      }
      _hubConnection!.on("ReceiveMessageThread", _receiveMessageThread);
      _hubConnection!.on("NewMessage", _newMessage);
    }
  }

  void _receiveMessageThread(List<Object>? parameters) {
    final messagesFromServer = parameters![0] as List<dynamic>;

    /*for (var element in messagesFromServer) {
      var mess = Message.fromJson(element);
      messages.add(mess);
    }*/
    final listMessage = messagesFromServer
        .map<Message>((json) => Message.fromJson(json))
        .toList();
    messages.value = listMessage;
  }

  void _newMessage(List<Object>? parameters) {
    final message = parameters![0] as Map<String, dynamic>;
    final mess = Message.fromJson(message);
    messages.add(mess);
  }

  Future<void> sendMessageToClient(String userNameTo, String content) async {
    await _hubConnection!.invoke("SendMessage", args: <Object>[
      {'RecipientUsername': userNameTo, 'Content': content}
    ]);
  }

  void clearMessage() {
    messages.clear();
  }

  void stopHubConnection() {
    if (_hubConnection != null) {
      _hubConnection!
          .stop()
          .catchError((e) => {debugPrint("Message hub at Stop: $e")});
      _hubConnection = null;
    }
  }
}
