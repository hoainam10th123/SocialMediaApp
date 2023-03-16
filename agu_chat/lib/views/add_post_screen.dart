
import 'package:agu_chat/services/postService.dart';
import 'package:agu_chat/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget{
  @override
  State<AddPostScreen> createState() {
    return AddPostScreenState();
  }
}

class AddPostScreenState extends State<AddPostScreen>{
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images;

  buildImageAvarta(){
    return Global.user!.imageUrl != null
        ? NetworkImage(Global.user!.imageUrl!)
        : const AssetImage('assets/images/user.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add post'),
        actions: [
          IconButton(
              onPressed: (){
                PostService().savePost(files: images, content: contentController.text)
                    .then((value) => Fluttertoast.showToast(
                    msg: value,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                ));
              },
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: buildImageAvarta(),
                  maxRadius: 25,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    Global.user!.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),)
              ],
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: contentController,
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: 10,
              decoration: const InputDecoration(
                  hintText: "Write content..."
              ),
            ),

            IconButton(
                onPressed: () async{
                  //image = await _picker.pickImage(source: ImageSource.gallery);
                  images = await _picker.pickMultiImage();
                },
                icon: Icon(Icons.image)
            )
          ],
        ),
      )
    );
  }

}