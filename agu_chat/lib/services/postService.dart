import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/const.dart';
import '../utils/global.dart';


class PostService{

  Future<String> savePost({String content = '', List<XFile>? files}) async{
    String messageRes = '';
    try {
      final uri = Uri.parse('$urlBase/api/posts');
      Map<String, String> headers= <String,String>{
        'Authorization':'Bearer ${Global.user!.token}',
      };

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['content'] = (content);

      if(files != null){
        files.forEach((file) {
          request.files.add(
              http.MultipartFile(
                  file.name,
                  File(file.path).readAsBytes().asStream(),
                  File(file.path).lengthSync(),
                  filename: file.name
              )
          );
        });
      }

      var res = await request.send();
      var responsed = await http.Response.fromStream(res);
      if(res.statusCode == 200){
        messageRes = '200';
        final responseData = jsonDecode(responsed.body);
        print(responseData);
      }else{
        messageRes = '${res.statusCode} ${res.reasonPhrase}';
      }
    } catch (e) {
      messageRes = e.toString();
    }
    return messageRes;
  }
}