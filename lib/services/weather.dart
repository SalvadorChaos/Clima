import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const apiKey = '8b15d508cf52103e30b2edd89beb59e1';
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=imperial');

    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=imperial');

    var weatherData = await networkHelper.getData();

    return weatherData;
  }

  String getBackgroundImage(int condition) {
    if (condition < 200) {
      return '3';
    } else if (condition < 300) {
      return '3';
    } else if (condition < 500) {
      return '3';
    } else if (condition < 600) {
      return '2';
    } else if (condition < 700) {
      return '2';
    } else if (condition == 800) {
      return '1';
    } else if (condition <= 804) {
      return '2';
    } else {
      return '0‍';
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 200) {
      return '🌩';
    } else if (condition < 300) {
      return '🌧';
    } else if (condition < 500) {
      return '☔️';
    } else if (condition < 600) {
      return '☃️';
    } else if (condition < 700) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷';
    }
  }

  String getMessage(int temp) {
    if (temp > 77) {
      return 'It\'s 🍦 time while';
    } else if (temp > 68) {
      return 'Time for shorts and a 👕 while';
    } else if (temp < 50) {
      return 'You\'ll need a 🧣 and 🧤 while';
    } else {
      return 'Bring a 🧥 just in case while';
    }
  }
}
