import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import '../../../utils/const.dart';

class GroupItem extends StatelessWidget{
  const GroupItem({Key? key}) : super(key: key);

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
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/netcore.png'),
                    maxRadius: 30,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(paddingAll),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cong dong dot net angular viet nam', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Sang mai anh ghe lay Sang mai anh ghe lay Sang mai anh ghe lay', overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            badges.Badge(
              badgeContent: Text('3', style: TextStyle(color: Colors.white, fontSize: 18),),
            )
          ],
        )
    );
  }

}