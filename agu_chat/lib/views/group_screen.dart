import 'package:agu_chat/views/widgets/chat/user_item.dart';
import 'package:agu_chat/views/widgets/group/group_item.dart';
import 'package:flutter/material.dart';

import 'detail_chat_screen.dart';

class GroupScreen extends StatelessWidget{
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group chat'),
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailChatScreen(userName: '',)),
              );
            },
            child: GroupItem(),
          )
      ),
    );
  }
  
}