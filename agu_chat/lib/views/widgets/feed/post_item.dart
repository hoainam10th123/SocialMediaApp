import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import '../../../models/post.dart';
import '../../../utils/const.dart';
import '../../detail_photo_screen.dart';
import '../modals/modal_list_comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatelessWidget {

  final Post post;

  const PostItem({super.key, required this.post});

  buildImageAvarta(){
    return post.imageUrl != null
        ? NetworkImage(post.imageUrl!)
        : const AssetImage('assets/images/user.png');
  }

  Widget buildCategoryPost(){
    var widget = const Text('Default', style: TextStyle(color: Colors.white, fontSize: fontSize));
    switch(post.category){
      case 0:
        widget = const Text('Bán hàng', style: TextStyle(color: Colors.white, fontSize: fontSize));
        break;
      case 1:
        widget = const Text('Trò chơi', style: TextStyle(color: Colors.white, fontSize: fontSize));
        break;
      case 2:
        widget = const Text('Video', style: TextStyle(color: Colors.white, fontSize: fontSize));
        break;
      default:
        widget = const Text('Default', style: TextStyle(color: Colors.white, fontSize: fontSize));
        break;
    }
    return widget;
  }

  Widget buildImagesContainer(BuildContext context){
    return post.images.isNotEmpty ? InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPhotoScreen(images: post.images,)),
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                image: NetworkImage(post.images[0].path),
                fit: BoxFit.fill
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text('+${post.images.length.toString()}', style: const TextStyle(fontSize: 30, color: Colors.white),),
        ),
      ),
    ) : Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(paddingAll),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: buildImageAvarta(),
                    maxRadius: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.displayName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(timeago.format(post.created)),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(Icons.public, size: 15,)
                            ],
                          ),
                        ],
                      )
                  ),
                  badges.Badge(
                    badgeAnimation: const badges.BadgeAnimation.slide(
                      toAnimate: true,
                      animationDuration: Duration(seconds: 1)
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.square,
                      badgeColor: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    badgeContent: buildCategoryPost(),
                  ),
                ],
              ),)
            ],
          ),
          Container(
            padding: const EdgeInsets.all(paddingAll),
            child: RichText(
              text: TextSpan(
                text:post.noiDung?? '',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
          ),
          buildImagesContainer(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.thumb_up_rounded,
                    color: Colors.blue,
                    size: 18,
                  ),
                  Text('22')
                ],
              ),
              Row(
                children: [
                  Text('${post.comments.length} comments'),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('30 shared')
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Icon(Icons.thumb_up_alt_outlined),
                  Text('Like')
                ],
              ),
              InkWell(
                onTap: (){
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: ModalListComment(postId: post.id, totalComments: post.comments.length,),
                      );
                    },
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.comment),
                    Text('Comments')
                  ],
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.share),
                  Text('Share')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
