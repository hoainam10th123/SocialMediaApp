import 'package:agu_chat/models/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/pagination.dart';
import '../../../utils/const.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../utils/global.dart';

//ModalListComment must have StatefulWidget, because prevent data in TextField when close keyboard
class ModalListComment extends StatefulWidget{
  final int postId;
  final int totalComments;

  const ModalListComment({super.key, required this.postId, required this.totalComments});

  @override
  State<StatefulWidget> createState() {
    return ModalListCommentState();
  }

}

class ModalListCommentState extends State<ModalListComment> {
  final TextEditingController contentController = TextEditingController();
  Pagination<Comment> paginationComment = Pagination(
      totalPages: 1,
      pageNumber: 1,
      pageSize: 5,
      count: 1,
      items: []
  );

  @override
  void initState() {
    super.initState();
    fetchComments(pageNumber).then((value) => debugPrint(value));

    Global.myStream!.commentStream.listen((event) {
      final comment = event as Comment;
      if(comment.postId == widget.postId){
        setState(() {
          comments.add(comment);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> sendComment(String noiDung, int postId) async{
    String messageRes = '';
    try {
      final uri = Uri.parse('$urlBase/api/comment?noidung=$noiDung&postId=$postId');

      var response = await http.post(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        messageRes = '200';
      } else {
        messageRes = '${response.statusCode} ${response.body}';
      }
    } catch (e) {
      messageRes = e.toString();
    }
    return messageRes;
  }

  int pageNumber = 1;
  List<Comment> comments = [];//display data
  double opacity  = 0.0;


  Future<String> fetchComments(int pageNumber) async{
    String messageRes = '';
    try {
      setState(() {
        opacity = 1.0;
      });
      await Future.delayed(const Duration(seconds: 2));
      final uri = Uri.parse('$urlBase/api/comment?pageNumber=$pageNumber&pageSize=10&postId=${widget.postId}');

      var response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        final data = Pagination<Comment>.fromJson(json, Comment.fromJsonModel);
        paginationComment = data;
        setState(() {
          opacity  = 0.0;
          comments.addAll(data.items);
        });
        messageRes = '200';
      } else {
        messageRes = '${response.statusCode} ${response.body}';
        setState(() {
          opacity  = 0.0;
        });
      }
    } catch (e) {
      messageRes = e.toString();
      setState(() {
        opacity  = 0.0;
      });
    }
    return messageRes;
  }

  buildImageAvarta(String? imageUrl){
    return imageUrl != null
        ? NetworkImage(imageUrl)
        : const AssetImage('assets/images/user.png');
  }

  buildUserAndComment(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: buildImageAvarta(comments[index].userImageUrl),
            radius: 20,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments[index].displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: TextSpan(
                    text: comments[index].noiDung,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Text('${widget.totalComments} comments',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
        ),
        child: Scaffold(
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
                      onPressed: () {
                        sendComment(contentController.text, widget.postId).then((value) => contentController.clear());
                      },
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
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
            height: MediaQuery.of(context).size.height - 170,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  if(pageNumber < paginationComment.totalPages){
                    pageNumber += 1;
                    fetchComments(pageNumber).then((value) => debugPrint(value));
                  }
                }
                return true;
              },
              child: ListView.builder(
                  itemCount: comments.length + 1,
                  itemBuilder: (context, index){
                    if(index == comments.length){
                      return Opacity(
                        opacity: opacity,
                        child: const Center(child: CircularProgressIndicator(color: Colors.deepOrange,),),
                      );
                    }
                    return buildUserAndComment(context, index);
                  }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
