import 'package:flutter/material.dart';

import '../pages/QRcheckin.dart';
import '../pages/films.dart';

class MenuListTileWidget extends StatelessWidget{
  const MenuListTileWidget({super.key});

  @override
  Widget build( BuildContext context ){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
            leading: Icon( Icons.video_file ),
            title: Text("Latest films"),

            onTap: () {
              Navigator.of(context).push( MaterialPageRoute(builder: (context) => Films() ) );
            }
        ),
        ListTile(
            leading: Icon(Icons.grid_4x4),
            title: Text("Categories"),
            onTap: () {}

        ),
        ListTile(
            leading: Icon(Icons.qr_code),
            title: Text("QR Check-in"),
            onTap: (){
              Navigator.of(context).push( MaterialPageRoute(builder: (context) => Checkin() ) );
            }
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: (){

            }
        ),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign out"),
            onTap: (){

            }
        ),
      ],
    );
  }
}