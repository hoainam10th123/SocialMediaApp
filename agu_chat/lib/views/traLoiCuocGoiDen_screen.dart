import 'package:agu_chat/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import '../services/agoraService.dart';
import '../utils/const.dart';

class TraLoiCuocGoiDenScreen extends StatefulWidget{
  @override
  State<TraLoiCuocGoiDenScreen> createState() {
    return TraLoiCuocGoiDenScreenState();
  }
}

class TraLoiCuocGoiDenScreenState extends State<TraLoiCuocGoiDenScreen>{
  double? _x = 20;
  double? _y = 50;
  final double leftWidthLocalVideoContainer = 150;
  final double topHeightLocalVideoContainer = 200;

  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
  }

  Future<void> initAgora() async {
    final res = await AgoraService().getRtcToken();
    if(res.message == '200'){
      // retrieve permissions
      await [Permission.microphone, Permission.camera].request();
      //create the engine
      _engine = await RtcEngine.create(appId);
      await _engine.enableVideo();
      _engine.setEventHandler(
        RtcEngineEventHandler(
          joinChannelSuccess: (String channel, int uid, int elapsed) {
            print("local user $uid joined");
            setState(() {
              _localUserJoined = true;
            });
          },
          userJoined: (int uid, int elapsed) {
            print("remote user $uid joined");
            setState(() {
              _remoteUid = uid;
            });
          },
          userOffline: (int uid, UserOfflineReason reason) {
            print("remote user $uid left channel");
            setState(() {
              _remoteUid = null;
            });
          },
        ),
      );
      await _engine.joinChannelWithUserAccount(res.data!.token, Global.channelName!, Global.user!.username);
    }else{
      print(res.message!);
      Fluttertoast.showToast(
          msg: res.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Widget buildLocalVideoWidget(){
    return SizedBox(
      width: leftWidthLocalVideoContainer, height: topHeightLocalVideoContainer,
      child: Center(
        child: _localUserJoined
            ? const RtcLocalView.SurfaceView()
            : const CircularProgressIndicator(),
      ),
    );
  }

  // Display remote user's video
  Widget remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: Global.channelName!,
      );
    } else {
      return const Center(child: Text(
          'Please wait for remote user to join',
          style: TextStyle(fontSize: 20, color: Colors.blueAccent)
      ),);
    }
  }

  buildModal(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {

              },
              child: Icon(Icons.videocam),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {

              },
              child: Icon(Icons.camera_alt),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {

              },
              child: Icon(Icons.mic),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                //thoat bottom bar va sau do thoat man hinh call
                Navigator.of(context)..pop()..pop();
              },
              child: Icon(Icons.call_end),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: (){
                showBarModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.03),
                  backgroundColor: Colors.transparent,
                  builder: (context) => buildModal(context),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: remoteVideo(),
              ),
            ),
            Positioned(
                left: _x,
                top: _y,
                child: Draggable(
                  feedback: buildLocalVideoWidget(),
                  childWhenDragging: buildLocalVideoWidget(),
                  onDragStarted: () {

                  },
                  onDragEnd: (draggabledetail) {
                    setState(() {
                      _x = draggabledetail.offset.dx;
                      _y = draggabledetail.offset.dy;
                    });
                  },
                  child: buildLocalVideoWidget(),
                ),
            ),
          ],
        ),
    );
  }

}