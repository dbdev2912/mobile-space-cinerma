import 'package:flutter/material.dart';
import 'package:space_cinema/services/BASE_CONFIG.dart';
import 'package:space_cinema/widgets/drawer.dart';

import '../services/BASE_URL.dart';



class HomePage extends StatelessWidget{
  HomePage({ Key? key, required this.username }) : super( key: key );
  final String username;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override

  Widget build(BuildContext context){
    return Scaffold(
        key: scaffoldKey,
        drawer: const LeftDrawerWidget(),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(239, 239, 239, 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
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
                          scaffoldKey.currentState!.openDrawer();
                        },
                        child: Icon( Icons.menu, color: Color.fromRGBO(129, 129, 129, 1), size: 32.0 )
                    ),

                    Container(
                      margin: const EdgeInsets.all(12.0),
                      child: const Text(
                          "SPACE CINEMA",
                          style: TextStyle(
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
                              backgroundImage: NetworkImage(BASE_SERVER_URL+"/images/logo.jpg"),
                            ),
                          )
                      ),
                    ),



                  ],
                )
              ),



            ],
          )
        )
    );
  }
}

