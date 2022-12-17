
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_cinema/services/session.dart';
import 'dart:convert';

import '../services/BASE_URL.dart';
import 'Home.dart';

class Login extends StatefulWidget{
  const Login({ Key? key}):super( key: key );
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login>{

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  Future<void> LoginRequest() async {
    var username = usernameController.text;
    var password = passwordController.text;

    var response = await Session().post("$BASE_URL/api/login",
      jsonEncode(<String, String>{
          "username": username,
          "password": password,
        })
    );

    if( true ){
      var data = response;
      if( data["success"] ){
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("username", username);
        sharedPreferences.setStringList("waitingList", []);
        Navigator.push( context, MaterialPageRoute(builder: (context) => HomePage( )));
      }
    }
  }

  @override
  void dispose(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override

  Widget build( BuildContext context ){
    return Scaffold(

      body: SafeArea(
        child:  Center(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("$BASE_SERVER_URL/images/login.jpg"),
                        fit: BoxFit.cover
                    )
                ),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255,255,255, 0.75),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 5.0, color: Colors.white),
                                        borderRadius: BorderRadius.circular(75.0),
                                      ),
                                      width: 150.0,
                                      height: 150.0,
                                      margin: const EdgeInsets.all(24),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(75.0),

                                              gradient: const LinearGradient(
                                                colors: [Color.fromRGBO(255, 102, 85, 1), Color.fromRGBO(153, 0, 0, 1)],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: CircleAvatar(
                                              backgroundImage:NetworkImage("$BASE_SERVER_URL/images/logo.jpg"),
                                            ),
                                          )
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.all(12.0),
                                      child: const Text(
                                          "SPACE CINEMA",
                                          style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(153, 0, 0, 1)
                                          )
                                      ),
                                    ),


                                    Form(
                                        child:
                                        Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin: const EdgeInsets.only(top: 8.0),
                                                      child:  Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: TextFormField(
                                                          controller: usernameController,
                                                          decoration: const InputDecoration(
                                                              hintText: "Username",
                                                              border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all( Radius.circular(12.0)),
                                                                  borderSide: BorderSide( color: Colors.black54, width: 1 )

                                                              )

                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Container(
                                                      margin: const EdgeInsets.only(top: 8.0),
                                                      child:  Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: TextFormField(
                                                          controller: passwordController,
                                                          obscureText: true,
                                                          decoration: const InputDecoration(
                                                              hintText: "Password",
                                                              border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.all( Radius.circular(12.0)),
                                                                  borderSide: BorderSide( color: Colors.black54, width: 1 )
                                                              )
                                                          ),
                                                        ),
                                                      )
                                                  ),

                                                  Container(
                                                      margin: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                                                      child: Padding(
                                                          padding: const EdgeInsets.all(12),
                                                          child: ElevatedButton(
                                                            onPressed: (){
                                                              LoginRequest();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12.0),
                                                              ),
                                                              backgroundColor: const Color.fromRGBO(153, 0, 0, 1),
                                                              minimumSize: const Size.fromHeight(50),
                                                            ),
                                                            child: const Text(
                                                                "Let's Go",
                                                                style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  color: Colors.white,
                                                                )
                                                            ),
                                                          )
                                                      )
                                                  )

                                                ]
                                            )
                                        )
                                    )
                                  ],
                                )
                            )
                        ),
                      ]
                  ),
                )
            )
        )
      )
    );
  }
}