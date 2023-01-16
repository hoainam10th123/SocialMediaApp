import 'dart:async';

import 'package:agu_chat/models/comment.dart';
import 'package:agu_chat/models/member.dart';
import 'package:agu_chat/stream/unReadMessage.dart';
import 'package:collection/collection.dart';

class MyStream {
  bool isSignOut = false;
  bool isInForeground = true;

  StreamController counterController = StreamController<bool>.broadcast();
  Stream get counterStream => counterController.stream;

  StreamController navigateScreenController = StreamController<Member>.broadcast();
  Stream get navigateScreenStream => navigateScreenController.stream;

  var unreadMessages = <UnreadMessage>[];
  StreamController unReadMessageController = StreamController<UnreadMessage>.broadcast();
  Stream get unReadMessageStream => unReadMessageController.stream;

  StreamController commentController = StreamController<Comment>.broadcast();
  Stream get commentStream => commentController.stream;

  StreamController foregroundController = StreamController<bool>.broadcast();
  Stream get foregroundStream => foregroundController.stream;

  void sendStatusAppLifecycleState(bool isInForeground){
    this.isInForeground = isInForeground;
    foregroundController.sink.add(isInForeground);
  }

  void sendComment(Comment comment){
    commentController.sink.add(comment);
  }

  void signOut() {
    isSignOut = true;
    counterController.sink.add(isSignOut);
  }

  void increaseUnreadMessage(String userName){
    var index = unreadMessages.indexWhere((element) => element.username == userName);
    if(index != -1){
      final temp = unreadMessages.firstWhereOrNull((element) => element.username == userName);
      final countMessage = UnreadMessage(username: userName, count: temp!.count + 1);
      unreadMessages[index] = countMessage;
      unReadMessageController.sink.add(countMessage);
    }else{
      final countMessage = UnreadMessage(username: userName, count: 1);
      unreadMessages.add(countMessage);
      unReadMessageController.sink.add(countMessage);
    }
  }

  void navigateToScreen(Member memberCalling){
    navigateScreenController.sink.add(memberCalling);
  }

  void dispose() {
    counterController.close();
    unReadMessageController.close();
    navigateScreenController.close();
    commentController.close();
  }
}