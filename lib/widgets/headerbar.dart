import 'package:flutter/material.dart';

import '../services/BASE_CONFIG.dart';

class HeaderBar extends StatelessWidget{
  const HeaderBar({ Key? key, required this.title }) : super( key: key );
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.white
            ),
            height: 120.0,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: const Icon( Icons.arrow_back, color: Color.fromRGBO(129, 129, 129, 1), size: 32.0 )
                ),

                Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: BASE_HEAD_BAR_FONT_SIZE,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(153, 0, 0, 1)
                      )
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 5.0, color: Colors.white),
                    borderRadius: BorderRadius.circular(75.0),
                  ),
                  width: 100.0,
                  height: 100.0,
                  margin: const EdgeInsets.all(12),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),

                          gradient: const LinearGradient(
                            colors: [Color.fromRGBO(255, 102, 85, 1), Color.fromRGBO(153, 0, 0, 1)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("/images/logo.jpg"),
                        ),
                      )
                  ),
                ),
              ],
            )
        ),
      )
    );

  }
}