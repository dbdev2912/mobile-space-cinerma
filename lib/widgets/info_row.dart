import 'package:flutter/material.dart';

class InforRow extends StatelessWidget{
  final String title;
  final String value;
  const InforRow({ Key? key, required this.title, required this.value }) : super( key: key );
  @override
  Widget build(BuildContext context){
    const padding = 4.0;
    return Scaffold(
      body: Container(

        child: Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(title),
                )
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(value, style: TextStyle(
                    fontWeight: FontWeight.w300,
                  )),
                )
            ),
          ],
        )
      )
    );
  }
}