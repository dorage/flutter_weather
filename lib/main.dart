import './configs.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String cityName = "seoul";

Future<Weather> fetchWeather() async {
  final res = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=${cityName}&appid=${apiKey}');

  if (res.statusCode == 200) {
    return Weather.fromJson(json.decode(res.body));
  } else {
    throw Exception("Failed to load a weather");
  }
}

class Weather {
  final String main; // 날씨 정보 ex)흐림, 안개 등
  final String country; // 나라
  final String cityName; // 검색도시
  final double temp; // 온도
  final double wind; // 풍속
  final int humidty; // 습도
  final int cloud; // 구름 %

  Weather({
    this.main,
    this.country,
    this.cityName,
    this.temp,
    this.humidty,
    this.wind,
    this.cloud,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json["weather"][0]["main"],
      country: json["sys"]["country"],
      cityName: json["name"],
      temp: json["main"]["temp"],
      humidty: json["main"]["humidity"],
      wind: json["wind"]["speed"],
      cloud: json["clouds"]["all"],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Weather>(
            future: futureWeather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Text(snapshot.data.main),
                    Text(snapshot.data.country),
                    Text(snapshot.data.cityName),
                    Text('${snapshot.data.temp}'),
                    Text('${snapshot.data.humidty}'),
                    Text('${snapshot.data.wind}'),
                    Text('${snapshot.data.cloud}'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
