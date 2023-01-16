import 'package:agu_chat/models/member.dart';
import 'package:agu_chat/views/cuocGoiDen_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../controllers/presenceHub.dart';
import '../services/oneSignalService.dart';
import '../utils/const.dart';
import 'package:get/get.dart';
import '../utils/global.dart';

class BottomNavbar extends StatefulWidget{
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar>{
  int pageIndex = 0;
  final presenceHubController = Get.put(PresenceHubController());
  OneSignalService oneSignalService = OneSignalService();

  @override
  void initState() {
    super.initState();
    presenceHubController.createHubConnection(Global.user);
    setState(() {
      pageIndex = 0;
    });
    initPlatformState();

    // call from presenceHub
    Global.myStream!.navigateScreenStream.listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CuocGoiDenScreen(member: event as Member,)),
      );
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //Remove this method to stop OneSignal Debugging
    //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("17f10dd1-d62a-43d9-bf73-6405535a8757");
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    Global.playerId = osUserID;

    if(osUserID != null){
      oneSignalService.postPlayerId(osUserID).then((value) => print(value));
    }
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index){
          setState(() {
            pageIndex = index;
          });
        },
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat, size: 35,), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.group, size: 35,), label: 'Group'),
          BottomNavigationBarItem(icon: Icon(Icons.rss_feed, size: 35,), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box, size: 35,), label: 'Profile'),
        ],),
    );
  }
}