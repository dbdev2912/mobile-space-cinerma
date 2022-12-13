import 'package:flutter/material.dart';

import '../services/BASE_URL.dart';
import 'drawer_menu_list.dart';

class LeftDrawerWidget extends StatelessWidget{
  const LeftDrawerWidget({
    Key? key
  }) : super( key: key );

  @override
  Widget build(BuildContext context){
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: Icon( Icons.face, size: 48, color: Colors.white ),
                accountName: Text("Sandy Smith"),
                accountEmail: Text("sandy.smith@gmail.com"),
                otherAccountsPictures: <Widget>[
                  Icon(Icons.bookmark_border, color: Colors.white,),
                ],
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(BASE_SERVER_URL+"/images/login.jpg"),
                        fit: BoxFit.cover
                    )
                )
            ),
            MenuListTileWidget(),
          ],
        )
    );
  }
}