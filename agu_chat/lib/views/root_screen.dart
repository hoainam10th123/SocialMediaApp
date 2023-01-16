import 'dart:convert';
import 'package:agu_chat/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../models/user.dart';
import '../utils/global.dart';
import 'bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class RootScreen extends StatefulWidget{
  @override
  State<RootScreen> createState() {
    return RootScreenState();
  }
}

class RootScreenState extends State<RootScreen> with WidgetsBindingObserver{
  AuthStatus authStatus = AuthStatus.notSignedIn;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //AppLifecycleState? _notification;
  static const platform = MethodChannel('agu.chat/signalR');

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  Future<void> startService(String token, String currentUsername) async {
    try {
      // comment dong nay neu app chay len bi crash, vi token bi het han
      await platform.invokeMethod('startSignalrService', {"token":token, "currentUsername": currentUsername});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /*switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        isInForeground = true;
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        isInForeground = false;
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        isInForeground = false;
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        isInForeground = false;
        break;
    }*/
    bool isInForeground = state == AppLifecycleState.resumed;
    Global.myStream!.sendStatusAppLifecycleState(isInForeground);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Global.myStream!.counterStream.listen((event) {
      if(event){//print(event);
        _updateAuthStatus(AuthStatus.notSignedIn);
      }
    });
    //read from local storages
    final user = _prefs.then((SharedPreferences prefs) {
      var json = prefs.getString('user');
      if(json == null){
        _updateAuthStatus(AuthStatus.notSignedIn);
        return null;
      }
      Map<String, dynamic> userJson = jsonDecode(json);
      final tempUser = User.fromJson(userJson);
      Global.user = tempUser;
      //call to native android
      startService(Global.user!.token, Global.user!.username);

      _updateAuthStatus(AuthStatus.signedIn);
      return tempUser;
    });
    FlutterNativeSplash.remove();
    // nhan event tu native, man hinh CallingActivity
    //platform.setMethodCallHandler(didRecieveTranscript);
  }

  /*Future<void> didRecieveTranscript(MethodCall call) async {
    // type inference will work here avoiding an explicit cast
    final String channelName = call.arguments;
    switch(call.method) {
      case "RecieveCallingScreen":
        {
          Global.channelName = channelName;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TraLoiCuocGoiDenScreen()),
          );
        }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginScreen(
          title: 'Login',
          onSignedIn: () => {
            _updateAuthStatus(AuthStatus.signedIn),
            startService(Global.user!.token, Global.user!.username)
          },
        );
      case AuthStatus.signedIn:
        return BottomNavbar();
    }
  }

}