import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/BASE_URL.dart';
import '../services/BASE_CONFIG.dart';
import '../services/session.dart';

class Film extends StatefulWidget{
  final dynamic film;
  const Film({ Key? key, required this.film }): super( key: key );
  @override
  _FilmState createState() => _FilmState();

}

class _FilmState extends State<Film>{

  late String buttonLabel;
  late dynamic film;
  // late StreamSubscription<ConnectivityResult> subscription;

  final Connectivity _connectivity = Connectivity();

  dynamic dataQueue = [];

  Future ticketTransaction() async {
    var req_url = "/api/cancel/ticket";
    if (!film["is_registed"]){
      req_url = "/api/register/ticket";
    }

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final obtainUsername = sharedPreferences.getString("username");
    final waitingList = sharedPreferences.getStringList("waitingList");
    var connected = await _connectivity.checkConnectivity();

    if( connected != ConnectivityResult.none ){
      var response = await Session().post(BASE_URL+req_url,
          jsonEncode(<String, String>{
            "id": film["film_id"].toString(),
            "user_obj": jsonEncode(<String, String?>{
              "username": obtainUsername
            })
          })
      );
      if( response["success"]  ){
        setState(() {
          film["is_registed"] = !film["is_registed"];
          buttonLabel = film["is_registed"] ? "Cancel my ticket" : "Get my ticket";
        });
      }
    }

    else{
      dynamic tempData = jsonEncode(<String, String>{
          "id": film["film_id"].toString(),
          "action": !film["is_registed"] ? "true" : "false",
          "username": obtainUsername!
        });

      waitingList!.add(tempData);
      sharedPreferences.setStringList("waitingList", waitingList);

      setState(() {
        film["is_registed"] = !film["is_registed"];
        buttonLabel = film["is_registed"] ? "Cancel my ticket" : "Get my ticket";
      });
    }
    //   dynamic tempData;
    //   tempData["url"] = req_url;
    //   tempData["body"] = jsonEncode(<String, String>{
    //     "id": film["film_id"].toString(),
    //     "user_obj": jsonEncode(<String, String?>{
    //       "username": obtainUsername
    //     })
    //   });
    //   print("Temporary data");
    //   print(tempData);
    //
    //   var waitingList = sharedPreferences.getStringList('waitingList');
    //   waitingList?.add(tempData);
    //   sharedPreferences.setStringList("waitingList", waitingList!);
    //

  }

  @override
  void initState() {
    super.initState();

    setState(() {

      film = widget.film;
      buttonLabel = film["is_registed"] ? "Cancel my ticket" : "Get my ticket";

      // subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // resendData(result);
      // });
    });
  }

  // void resendData(ConnectivityResult result) async{
  //   // print("Connectivity change");
  //   if( result != ConnectivityResult.none ){
  //     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //     final obtainUsername = sharedPreferences.getString("username");
  //     for( var i = 0; i < dataQueue.length; i++ ){
  //       var data = jsonDecode(dataQueue[i]);
  //       await Session().post(BASE_URL+data["url"], data["body"] );
  //       print("Sent de fucking queue data!");
  //     }
  //
  //     setState(() {
  //       dataQueue = [];
  //
  //     });
  //   }
  // }

  @override
  dispose() {
    super.dispose();
    // subscription.cancel();
  }

  @override
  Widget build(BuildContext context){

    const padding = 12.0;
    final date = DateTime.parse(film["release_schedule"]);

    return Scaffold(
      body: SafeArea(
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
                          film["title"],
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
              child: Container(
                margin: const EdgeInsets.only(top: 12.0),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          child: Image.network(
                              BASE_URL + film["img"],
                              fit: BoxFit.fill
                          )
                      ),

                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: InkWell(
                          onTap: (){ ticketTransaction(); },

                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromRGBO(255, 102, 85, 1), Color.fromRGBO(153, 0, 0, 1)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  buttonLabel
                                  ,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                  )
                              ),
                            )
                          )
                        ),
                      ),


                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text("Categories"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text(film["categories_string"], style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text( "Language"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text(film["categories_string"], style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text( "Release year"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text(film["release_year"], style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text( "Premiere on"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text("${ date.day } - ${ date.month } - ${ date.year }", style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text("Length"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text(film["length"] + " minute(s)", style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color.fromRGBO(133, 133, 133, 1) ))
                                  ),
                                  child:                                 Row(
                                    children: <Widget>[
                                      const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(padding),
                                            child: Text( "Rating"),
                                          )
                                      ),
                                      Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(padding),
                                            child: Text(film["rating"], style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                            )),
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                                Container(

                                  margin: const EdgeInsets.only(top: padding, bottom: padding),
                                  child: Padding(
                                    padding: const EdgeInsets.all(padding),
                                    child: Text(film["description"]),
                                  )
                                )

                              ],
                            )
                          )
                      )

                    ],
                  ),
                )
              )
            ),

  

          ],
        )
      )
    );
  }

}