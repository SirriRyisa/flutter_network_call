import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:saifty_app_demo/movie_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MovieItem> movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text("Fancy Movies"),
        ),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
                leading: Image.network(
                  movies[position].poster,
                  width: 60,
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        movies[position].title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 228, 140, 134),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          movies[position].type,
                          style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Color.fromARGB(255, 235, 144, 138),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          },
          separatorBuilder: (context, Position) {
            return Divider(
              height: 10,
            );
          },
          itemCount: movies.length,
        ));
  }
  

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    final dio = Dio();
    String url = "http://www.omdbapi.com/?apikey=1bd9bfbf&s=Batman&page=2";
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      // List<String, int> sample = ["33", 5];
      var encoded = jsonEncode(response.data);
      Map<String, dynamic> result = jsonDecode(
        encoded,
      );

      var searchResult = result["Search"];
      for (var movie in searchResult) {
        MovieItem movieItem = MovieItem(
            imdbIDm: movie["imdbID"],
            poster: movie["Poster"],
            title: movie["Title"],
            type: movie["Type"],
            year: movie["Year"]);
        movies.add(movieItem);
      }

      setState(() {});
    }
  }
}
