import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import '../controllers/presenceHub.dart';
import '../services/agoraService.dart';
import '../utils/const.dart';
import '../utils/global.dart';

class CuocGoiDiScreen extends StatefulWidget{
  final String username;

  const CuocGoiDiScreen({super.key, required this.username});

  @override
  State<CuocGoiDiScreen> createState() {
    return CuocGoiDiScreenState();
  }
}

class CuocGoiDiScreenState extends State<CuocGoiDiScreen>{
  final PresenceHubController presenceHub = Get.find();
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
  void dispose() async{
    await _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> initAgora() async {
    final channelName = Global.user!.username;
    Global.channelName = channelName;
    final res = await AgoraService().getRtcToken();
    if(res.message == '200'){
      await presenceHub.callToUser(widget.username, channelName);
      // retrieve permissions
      await [Permission.microphone, Permission.camera].request();
      //create the engine
      _engine = createAgoraRtcEngine();
      await _engine.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      await _engine.enableVideo();
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("local user ${connection.localUid} joined");

            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            setState(() {
              _remoteUid = null;
            });
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
        ),
      );
      //await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      await _engine.startPreview();
      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );
      await _engine.joinChannelWithUserAccount(
        token: res.data!.token,
        channelId: Global.channelName!,
        userAccount: Global.user!.username,
        options: options,
      );
    }else{
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
            ? AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  // Display remote user's video
  Widget remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: Global.channelName),
        ),
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
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      height: 100,
                      color: Colors.black.withOpacity(0.03),
                      child: buildModal(context)
                  );
                },
              );
            },
            child: remoteVideo(),
          ),
          Positioned(
            left: _x,
            top: _y,
            child: buildLocalVideoWidget()
          ),
        ],
      ),
    );
  }

}