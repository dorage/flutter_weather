import '../configs.dart';

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
  final String icon; // 날씨 icon id
  final String country; // 나라
  final String cityName; // 검색도시
  final double wind; // 풍속 m/s
  final int temp; // 온도
  final int humidty; // 습도 %
  final int cloud; // 구름 %

  Weather({
    this.main,
    this.country,
    this.cityName,
    this.icon,
    this.temp,
    this.humidty,
    this.wind,
    this.cloud,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json["weather"][0]["main"].toString(),
      icon: json["weather"][0]["icon"].toString(),
      country: json["sys"]["country"].toString(),
      cityName: json["name"].toString(),
      temp: json["main"]["temp"].toInt(),
      humidty: json["main"]["humidity"].toInt(),
      wind: json["wind"]["speed"].toDouble(),
      cloud: json["clouds"]["all"].toInt(),
    );
  }
}

class WeatherInfo extends StatefulWidget {
  @override
  _WeatherInfoState createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Weather>(
            future: futureWeather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _refreshContainer(),
                    // Weather Icon
                    Image.network(
                      getIconURL(snapshot.data.icon),
                    ),
                    Text('${snapshot.data.cityName}, ${snapshot.data.country}'),
                    _mainInfoContainer(snapshot),
                    _specInfoContainer(snapshot),
                    SizedBox(height: 50),
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

  void _refresh() {
    print('refreshing fetch data');
    setState(() {
      futureWeather = fetchWeather();
    });
  }

  Widget _refreshContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: _refresh,
          child: Row(
            children: <Widget>[
              Text(
                'refresh',
                style: TextStyle(color: Colors.grey),
              ),
              Icon(Icons.refresh, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(width: 10)
      ],
    );
  }

  Widget _mainInfoContainer(snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('${snapshot.data.temp} ºC', style: TextStyle(fontSize: 48)),
        SizedBox(width: 40),
        Text(
          snapshot.data.main,
          style: TextStyle(fontSize: 48),
        ),
      ],
    );
  }

  Widget _specInfoContainer(snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _specInfo(smallIcons["humidity"], snapshot.data.humidty, '%'),
        _specInfo(smallIcons["wind"], snapshot.data.wind, 'm/s'),
        _specInfo(smallIcons["cloud"], snapshot.data.cloud, '%'),
      ],
    );
  }

  Widget _specInfo(iconUrl, data, unit) {
    return Row(
      children: <Widget>[
        Image.network(iconUrl, width: 16),
        SizedBox(width: 10),
        Text('${data} ${unit}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
