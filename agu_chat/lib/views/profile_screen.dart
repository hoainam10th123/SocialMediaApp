import 'package:agu_chat/views/widgets/profile/avarta_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/presenceHub.dart';
import '../utils/const.dart';
import '../utils/global.dart';
import 'package:get/get.dart';
import 'traLoiCuocGoiDen_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final PresenceHubController presenceHub = Get.find();

  buildText(){
    if(Global.playerId != null){
      return Text(Global.playerId!);
    }else{
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: ()async{
                  final SharedPreferences prefs = await _prefs;
                  // Remove data
                  final success = await prefs.remove('user');
                  // this stream is init at root page
                  Global.myStream!.signOut();
                  Global.clearData();
                  presenceHub.stopHubConnection();
                },
                icon: const Icon(Icons.logout)
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(paddingAll),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueAccent),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/google-flutter-logo.png'),
                          fit: BoxFit.fitWidth
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -100,
                      child: AvartaName(displayName: 'Nguyen Hoai Nam',)
                  )
                ],
              ),
              Container(
                  padding: EdgeInsets.only(top: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, size: 50,),
                      onPressed: (){
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CuocGoiDenScreen()),
                        );*/
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt, size: 50,),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TraLoiCuocGoiDenScreen()),
                        );
                      },
                    )
                  ],
                )
              ),
              SizedBox(height: 20,),
              buildText(),
            ],
          ),
        ),
    );
  }
}
