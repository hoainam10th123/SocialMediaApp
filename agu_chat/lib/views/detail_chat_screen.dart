import 'dart:async';

import 'package:agu_chat/models/member.dart';
import 'package:agu_chat/services/userService.dart';
import 'package:agu_chat/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/messageHub.dart';
import '../utils/const.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'cuocGoiDi_screen.dart';

class DetailChatScreen extends StatefulWidget{
  final String userName;

  DetailChatScreen({Key? key, required this.userName});

  @override
  State<DetailChatScreen> createState() {
    return DetailChatScreenState();
  }
}

class DetailChatScreenState extends State<DetailChatScreen>{
  final TextEditingController contentController = TextEditingController();
  final MessagesHubController messageHubCtr = Get.put(MessagesHubController());

  final ScrollController _controller = ScrollController();

  Member member = Member(
      unReadMessageCount: 0,
      userName: '',
      displayName: '',
      lastActive: DateTime.now(),
      photoUrl: null
  );

  void scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    UserService().getMember(widget.userName).then((value) => {
      if(value.message == '200'){
        setState(() {
          member = value.data!;
        })
      }
    });
    messageHubCtr.createHubConnection(Global.user, widget.userName);
    //set timeout
    final timer = Timer(const Duration(seconds: 2), () => scrollDown());
  }

  buildIcons(int index){
    return GestureDetector(
      onTap: (){
        contentController.text += iconsCustom[index];
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        child: Text(iconsCustom[index], style: const TextStyle(fontSize: 26),),
      ),
    );
  }

  buildImageAvarta(){
    return member.photoUrl != null
        ? NetworkImage(member.photoUrl!)
        : const AssetImage('assets/images/user.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    // event exit chat screen with people, back button on app bar
                    messageHubCtr.clearMessage();
                    messageHubCtr.stopHubConnection();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: buildImageAvarta(),
                  maxRadius: 25,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        member.displayName!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(timeago.format(member.lastActive!),
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Icon(
                    Icons.video_call,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CuocGoiDiScreen(username: widget.userName,)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
          padding: const EdgeInsets.all(5),
          height: 120,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(30),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  FloatingActionButton(
                    onPressed: () async{
                      if(contentController.text.isNotEmpty){
                        await messageHubCtr.sendMessageToClient(widget.userName, contentController.text);
                        scrollDown();
                        contentController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: iconsCustom.length,
                      itemBuilder: (context, index) => buildIcons(index)
                  ),
                ),
              )
            ],
          )
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height  - 200 ,
        child: Obx(()=>ListView.builder(
            controller: _controller,
            itemCount: messageHubCtr.messages.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index){
              final leftOrRight = messageHubCtr.messages[index].senderUsername == Global.user?.username;
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: leftOrRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftOrRight ? Text(''): CircleAvatar(
                        backgroundImage: buildImageAvarta(),
                        radius: 15,
                      ),
                      const SizedBox(width: 5,),
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[200],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          messageHubCtr.messages[index].content!,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  )
              );
            }
        ),)
      ),
    );
  }

}