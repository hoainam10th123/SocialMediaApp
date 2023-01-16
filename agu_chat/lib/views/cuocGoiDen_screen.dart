import 'dart:typed_data';

import 'package:agu_chat/models/member.dart';
import 'package:agu_chat/views/traLoiCuocGoiDen_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CuocGoiDenScreen extends StatefulWidget{
  final Member member;

  const CuocGoiDenScreen({super.key, required this.member});

  @override
  State<CuocGoiDenScreen> createState() {
    return CuocGoiDenScreenState();
  }

}


class CuocGoiDenScreenState extends State<CuocGoiDenScreen>{
  AudioPlayer player = AudioPlayer();
  bool isAnswerCallPressed = false;// mac dinh show man hinh cuoc goi den

  buildImageAvarta(){
    return widget.member.photoUrl != null
        ? NetworkImage(widget.member.photoUrl!)
        : const AssetImage('assets/images/user.png');
  }

  buildInforCallIngHeader(){
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: buildImageAvarta(),
          radius: 50,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(widget.member.displayName!,
          style: const TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        const Text('Cuộc gọi video đến', style: TextStyle(fontSize: 20, color: Colors.white70),)
      ],
    );
  }

  buildAnswerButton(BuildContext context){
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Từ chối', style: TextStyle(color: Colors.white, fontSize: 20),)
          ],
        ),
        const SizedBox(width: 80,),
        Column(
          children: [
            SizedBox(
              width: 65, height: 65,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAnswerCallPressed = true;
                    player.stop();
                  });
                },
                child: Icon(Icons.videocam),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('Trả lời', style: TextStyle(color: Colors.white, fontSize: 20))
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAudio();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.stop();
  }

  void playAudio() async{
    await player.play(AssetSource('sound/FacebookMessengerCall.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    //isAnswerCallPressed == false; mac dinh la man hinh cuoc goi den
    return isAnswerCallPressed == false? Scaffold(
        body: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                          image: buildImageAvarta(),
                          fit: BoxFit.fitHeight
                      ),
                      borderRadius: BorderRadius.circular(4)),
                ),
                Positioned(
                    top: 100,
                    child: buildInforCallIngHeader()
                ),
                Positioned(
                    bottom: 80,
                    child: buildAnswerButton(context)
                ),
              ],
            )
          ],
        )
    ) : TraLoiCuocGoiDenScreen();
  }

}