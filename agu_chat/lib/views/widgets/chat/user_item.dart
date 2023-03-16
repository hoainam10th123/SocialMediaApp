import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/presenceHub.dart';
import '../../../utils/const.dart';
import 'package:badges/badges.dart' as badges;

class UserItem extends StatelessWidget {
  final String username;
  final String displayName;
  final String content;
  int unreadMessage = 0;
  String? imageUrl;// fix error type NULL not sub type of String, because senderImgUrl can return null

  UserItem(
      {Key? key,
      required this.username,
      required this.displayName,
      required this.content,
        required this.imageUrl,
        required this.unreadMessage
      })
      : super(key: key);

  final PresenceHubController presenceHub = Get.find();

  buildImageAvarta(){
    return imageUrl != null
        ? NetworkImage(imageUrl!)
        : const AssetImage('assets/images/user.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(paddingAll),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: buildImageAvarta(),
                        maxRadius: 30,
                      ),
                      Obx(() => presenceHub.users.firstWhereOrNull(
                                  (element) => element.userName == username) !=
                              null
                          ? const Positioned(
                              right: 0,
                              bottom: 1,
                              child: Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 20,
                              ))
                          : const Text('')),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(paddingAll),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            content,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            badges.Badge(
                badgeContent: getBadgeText()
            ),
          ],
        ));
  }

  Widget getBadgeText(){
    if(unreadMessage > 0){
      return Text(unreadMessage.toString(), style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold));
    }
    return const Text("");
  }
}
