import 'package:flutter/material.dart';

import '../../../utils/const.dart';

class UserInfor extends StatelessWidget{
  final String displayName;
  UserInfor({Key? key, required this.displayName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(paddingAll),
          width: MediaQuery.of(context).size.width*0.2,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.png'),
                    maxRadius: 30,
                  ),
                  Positioned(
                      right: 0,
                      bottom: 1,
                      child: const Icon(Icons.circle, color: Colors.green, size: 20,)
                  )
                ],
              ),
              Text(displayName, overflow: TextOverflow.ellipsis)
            ],
          ),
        )
    );
  }

}