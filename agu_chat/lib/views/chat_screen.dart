import 'package:agu_chat/views/widgets/chat/user_infor.dart';
import 'package:agu_chat/views/widgets/chat/user_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../controllers/presenceHub.dart';
import '../utils/global.dart';
import 'detail_chat_screen.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final PresenceHubController presenceHub = Get.find();

  @override
  void initState() {
    super.initState();
    presenceHub.fetchLastMessages().then((value) => {
      if(value != '200'){
        Fluttertoast.showToast(
            msg: value,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        )
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login as ${Global.user!.displayName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => Text(
                '${presenceHub.users.length} online',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 90,
              child: Obx(
                () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: presenceHub.users.length,
                    itemBuilder: (context, index) => UserInfor(
                          displayName: presenceHub.users[index].displayName!,
                        )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 190,
              child: Obx(
                () => presenceHub.isLoading.value == true ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: presenceHub.lastMessages.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailChatScreen(userName: presenceHub
                                          .lastMessages[index].senderUsername,)
                                  ),
                                );
                              },
                              child: UserItem(username: presenceHub
                                  .lastMessages[index].senderUsername,
                                displayName: presenceHub
                                    .lastMessages[index].senderDisplayName,
                                content:
                                presenceHub.lastMessages[index].content,
                                imageUrl: presenceHub.lastMessages[index].senderImgUrl,
                                unreadMessage: presenceHub.lastMessages[index].unreadCount,
                              ),
                            )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
