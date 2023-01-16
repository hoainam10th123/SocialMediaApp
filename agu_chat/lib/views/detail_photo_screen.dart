import 'package:flutter/material.dart';

import '../models/imageOfPost.dart';

class DetailPhotoScreen extends StatelessWidget{
  final List<ImageOfPost> images;

  const DetailPhotoScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white.withOpacity(0.2),
        appBar: AppBar(
        backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      body: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(images[index].path),
                    fit: BoxFit.fitHeight
                ),
          )
      ),
    ),);
  }

}