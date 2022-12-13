import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/BASE_CONFIG.dart';
import '../services/BASE_URL.dart';
import '../services/session.dart';

class CheckinDetail extends StatefulWidget {
  final String id;

  const CheckinDetail({ Key? key, required this.id }) :super(key: key);

  @override
  _DetailState createState() => _DetailState();

}
class _DetailState extends State<CheckinDetail>{

  late Future<dynamic> checkinInfo;

  Future<dynamic> getDataAsync() async {
    const req_url = "/api/checkin";
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final obtainUsername = sharedPreferences.getString("username");

    var response = await Session().post(BASE_URL+req_url,
        jsonEncode(<String, String>{
          "_id": widget.id,
          "username": obtainUsername!
          }
     ));
    return response;
  }


  @override
  void initState() {
    super.initState();
    checkinInfo = getDataAsync();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
          child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                                Navigator.of(context).pop();
                              },
                              child: const Icon( Icons.arrow_back, color: Color.fromRGBO(129, 129, 129, 1), size: 32.0 )
                          ),

                          Container(
                            margin: const EdgeInsets.all(12.0),
                            child: Text(
                                "Checkin infor",
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
                                    backgroundImage: NetworkImage("$BASE_SERVER_URL/images/logo.jpg"),
                                  ),
                                )
                            ),
                          ),
                        ],
                      )
                  ),

                 Expanded(
                    child: FutureBuilder(
                      future: checkinInfo,
                      builder: ( BuildContext context, AsyncSnapshot snapshot ){
                        if( snapshot.hasData ){
                          final data = snapshot.data;
                          print(data);
                          if( data["success"] ){
                            return Container(
                              margin: EdgeInsets.only(top: 12.0),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                          BASE_SERVER_URL+data["infor"]["film"]["img"],
                                        fit: BoxFit.fill,
                                      )
                                    ),
                                    Expanded(
                                      child: Text("You're in!", textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: 16.0,
                                      )),
                                    ),
                                    Expanded(
                                      child: Text("The film is ablout to premiere soon, take your seat at position ${ data["infor"]["seat"] } and enjoy", textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: 14.0,
                                      )),
                                    ),
                                  ]
                                )
                              )
                            );
                          }else{
                            return Center(
                              child: Text(data["infor"]["msg"]),
                            );
                          }
                          
                        }else{
                          return CircularProgressIndicator();
                        }
                      }
                    )
                  )

                ],
              )
          )
      )
    );
  }
}