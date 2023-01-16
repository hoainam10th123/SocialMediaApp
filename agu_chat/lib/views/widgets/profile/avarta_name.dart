import 'package:flutter/material.dart';

class AvartaName extends StatelessWidget {
  final String displayName;

  const AvartaName({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const CircleAvatar(
              radius: 85,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/netcore.png'),
                radius: 80,
              ),
            ),
            Text(
              displayName,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            )
          ],
        ),
        Positioned(
            right: 20,
            bottom: 30,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.white70,
              child: Icon(
                Icons.camera_alt,
                size: 25,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}
