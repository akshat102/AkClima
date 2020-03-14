import 'package:clima/utilities/constants.dart';

import 'location.dart';
import 'networking.dart';

class WeatherModel {
  double latitude;
  double longitude;
  Future<dynamic> getLocationWeather() async{
  Location location = Location();
  await location.getCurrentLocation();
  latitude = location.latitude;
  longitude = location.longitude;

  NetworkHelper networkHelper = NetworkHelper(
      "$openweatherMapURL?lat=$latitude&lon=$longitude&units=metric&appid=$apikey");
  var weatherData = await networkHelper.getData();
  return weatherData;
}
Future<dynamic> getCityWether(String cityname) async{
var url = '$openweatherMapURL?q=$cityname&appid=$apikey&units=metric';
NetworkHelper networkHelper = NetworkHelper(url);
var wetherData = networkHelper.getData();
return wetherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
