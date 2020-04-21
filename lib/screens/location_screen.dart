import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../services/weather.dart';
import '../utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  int temp;
  bool convertToCelsius;
  String scale;
  String weatherIcon;
  String message;
  String city;
  String backgroundNumber;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        backgroundNumber = '0';
        scale = '';
        temp = 0;
        weatherIcon = 'Error';
        message = 'Unable to get any weather data';
        city = '';
        return;
      }

      var condition = weatherData['weather'][0]['id'];

      backgroundNumber = weather.getBackgroundImage(condition);

      convertToCelsius = false;
      scale = Platform.isIOS ? 'ᶠ' : 'f';

      double temperature = weatherData['main']['temp'];
      temp = temperature.toInt();

      weatherIcon = weather.getWeatherIcon(condition);

      message = weather.getMessage(temp);

      city = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        elevation: 0.0,
        leading: FlatButton(
          onPressed: () async {
            var weatherData = await weather.getLocationWeather();
            updateUI(weatherData);
          },
          child: Icon(
            Icons.near_me,
            size: 60.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              var typedCity = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CityScreen();
                  },
                ),
              );
              if (typedCity != null) {
                var weatherData = await weather.getCityWeather(typedCity);
                updateUI(weatherData);
              }
            },
            child: Icon(
              Icons.location_city,
              size: 60.0,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('images/location_background$backgroundNumber.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          convertToCelsius = !convertToCelsius;
                          if (convertToCelsius == true) {
                            temp = ((temp - 32) * 5 / 9).round();
                            scale = Platform.isIOS ? 'ᶜ' : 'c';
                          } else {
                            temp = ((temp * 9 / 5) + 32).round();
                            scale = Platform.isIOS ? 'ᶠ' : 'f';
                          }
                        });
                      },
                      child: Text(
                        '$temp°',
                        style: kTempTextStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          convertToCelsius = !convertToCelsius;
                          if (convertToCelsius == true) {
                            temp = ((temp - 32) * 5 / 9).round();
                            scale = Platform.isIOS ? 'ᶜ' : 'c';
                          } else {
                            temp = ((temp * 9 / 5) + 32).round();
                            scale = Platform.isIOS ? 'ᶠ' : 'f';
                          }
                        });
                      },
                      child: Text(
                        '$scale ',
                        style: kMessageTextStyle,
                      ),
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $city!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
