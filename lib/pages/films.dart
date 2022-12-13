import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/BASE_CONFIG.dart';
import '../services/BASE_URL.dart';
import 'film.dart';



class Films extends StatefulWidget {
    @override
    FilmState createState() => FilmState();
}

class FilmState extends State<Films>{

  late String finalUsername;
  late Future<dynamic> films;

  Future <dynamic> getLatestFilm ( String username ) async {
    final response = await http.get(Uri.parse("$BASE_URL/api/films/$username"));
    if( response.statusCode == 200 ){
      var rawJson = jsonDecode(response.body);
      var films = rawJson["films"];
      return films;
    }
    else{
      return null;
    }
  }

  Future getPreferencesData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final obtainUsername = sharedPreferences.getString("username");
    setState(() {
      finalUsername = obtainUsername!;
      films = getLatestFilm(finalUsername);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferencesData();
  }

  @override
  Widget build( BuildContext context ){
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
                            "Latest films",
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
                    future: films,
                    builder: ( BuildContext context, AsyncSnapshot snapshot ){
                      if( snapshot.hasData ){
                        final films = snapshot.data;
                        return ListView.builder(
                            itemCount:  films.length,
                            shrinkWrap: true,
                            itemBuilder: ( BuildContext context, int index ){
                              final film = films[index];
                              return  Container(
                                  margin: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(width: 1.0, color: const Color.fromRGBO(0, 0, 0, 0.5))
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Container(
                                                    child: Image.network(
                                                      BASE_URL + film["img"],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  )

                                              ),
                                              Expanded(
                                                child:  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget> [
                                                        Container(
                                                          child: Text(
                                                            film["title"].toUpperCase(),
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              color: Color.fromRGBO(153, 0, 0, 1),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            film["description"],
                                                            textAlign: TextAlign.justify,
                                                          ),
                                                        ),
                                                        Container(

                                                            child: ElevatedButton(
                                                              onPressed: (){
                                                                Navigator.of(context).push( MaterialPageRoute(builder: (context) => Film(film: film) ) );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: const Color.fromRGBO(153, 0, 0, 1),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: const [
                                                                  Text("More detail", style: TextStyle(color: Colors.white)),
                                                                  Icon( Icons.arrow_forward , color: Colors.white)
                                                                ],
                                                              ),
                                                            )
                                                        ),

                                                      ],
                                                    )
                                                ),
                                              )

                                            ],
                                          )
                                      )
                                  )
                              );
                            }
                        );
                      }else{
                        return const Center(child: CircularProgressIndicator());
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