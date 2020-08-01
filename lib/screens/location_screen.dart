import 'package:clima/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/services/weather.dart';
import 'package:weather_icons/weather_icons.dart';

import 'animated_screen.dart';


class LocationScreen extends StatefulWidget {
  final dynamic locationweather;
  LocationScreen({this.locationweather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

var condition;
String main;
String description;
String icon;
WeatherModel weatherModel = WeatherModel();
var temperature;
var pressure;
var humidity;
var temp_min;
var temp_max;

var visibility;
String visibilityString;
var speed;
String country;
String cityname;
var timezone;

DateTime sunrise;
String formattedSunriseTime = '';
String formattedSunriseDate = '';
DateTime sunset;
String formattedSunsetTime = '';
String formattedSunsetDate = '';


DateTime now = DateTime.now();
String formattedTime = '';
String formattedDate = '';

int clouds;

 @override
  void initState() {
    super.initState();
    formattedTime = DateFormat('KK:mm a').format(now);
    formattedDate = DateFormat('EEEEEE, d MMM').format(now);
    updateUI(widget.locationweather);
 }

 String weatherMessage;
 void updateUI(dynamic weatherData){
  setState(() {
    if(weatherData.toString()!='404') {
      condition = weatherData['weather'][0]['id'];
      main = weatherData['weather'][0]['main'];
      description = weatherData['weather'][0]['description'];
      icon = weatherData['weather'][0]['icon'];

      temperature = weatherData['main']['temp'];

      weatherMessage = weatherModel.getMessage(temperature.toInt());
      pressure = weatherData['main']['pressure'];
      humidity = weatherData['main']['humidity'];
      temp_min = weatherData['main']['temp_min'];
      temp_max = weatherData['main']['temp_max'];


      speed = weatherData['wind']['speed'];
      country = weatherData['sys']['country'];
      sunrise = DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunrise']*1000);
      formattedSunriseTime = DateFormat('KK:mm a').format(sunrise);
      formattedSunriseDate = DateFormat('EEEEEE, d MMM').format(sunrise);
      sunset = DateTime.fromMillisecondsSinceEpoch(weatherData['sys']['sunset']*1000);
      formattedSunsetTime = DateFormat('KK:mm a').format(sunset);
      formattedSunsetDate = DateFormat('EEEEEE, d MMM').format(sunset);

      clouds = weatherData['clouds']['all'];

      visibility = weatherData['visibility'] ?? -1;
      if (visibility >=0 && visibility < 1000)
          visibilityString = visibility.toString() + ' m';
        else if(visibility >=0){
          visibility /= 1000;
          visibilityString = visibility.toString() + ' km';
        }
        else
        visibilityString = ' ';
      timezone = weatherData['timezone'];
      cityname = weatherData['name'];
    }
    else{
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 10.0,
                title: Text("No Data Found!"),
                content: Text("Please Enter a Different City"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
      });
    }
  });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text('AkClime'),
        leading: FlatButton(
          onPressed: () async {
           var weatherData = await weatherModel.getLocationWeather();
              updateUI(weatherData);
          },
          child: Icon(
            Icons.near_me,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              var typeName = await Navigator.push(context, MaterialPageRoute(builder: (context) => CityScreen()));
           if(typeName!= null){
             var wetherData = await weatherModel.getCityWether(typeName);
           updateUI(wetherData);
           }
            },
            child: Icon(
              Icons.location_city,
              size: 30.0,
            ),
          ),
        ],
        elevation: 0.0,
      ),
      body: Container(
              color: bgColor,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                padding: EdgeInsets.only(top: 30),
                children: <Widget>[
                timeAndDay(formattedTime, 40.0, formattedDate, 20.0),
                SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 10),
                    child: Text(
                      '$cityname, $country',
                      style: TextStyle(fontSize: 30.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 5.0, top: 20.0),
                        child: Text(
                          '${temperature.toInt()}',
                          style: TextStyle(fontSize: 120.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0,top: 30),
                        child: Text('°C',
                          style: TextStyle(fontSize: 40.0),
                        ),
                      ),
                    ],
                  ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      temp(' min ',Colors.green),
                      temp('  |  ',Colors.white70),
                      temp(' max ',Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      temp(' ${temp_min.toString()} °C',Colors.green),
                      temp('  |  ', Colors.white70),
                      temp(' ${temp_max.toString()} °C',Colors.redAccent),
                    ],
                  ),
                  SizedBox(height: 50,),
                  divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "${WeatherModel().getMessage(temperature.toInt())} at $cityname!",
                      textAlign: TextAlign.center,
                      style: kMessageTextStyle,
                    ),
                  ),
                  SizedBox(height: 20,),
                  divider(),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    heads('Sunrise'),BoxedIcon(WeatherIcons.sunrise,color: Colors.grey,),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                  child: formatted(formattedSunriseTime, 20, formattedSunriseDate, 20, Colors.white),
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  children: <Widget>[
                                    heads('Wind'),
                                    BoxedIcon(WeatherIcons.day_rain_wind,color: Colors.grey,),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                  child: fields('$speed km/h')
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  children: <Widget>[
                                    heads('Humidity'),
                                    BoxedIcon(WeatherIcons.humidity,color: Colors.grey,),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: fields('$humidity %')
                                ),
                                SizedBox(height: 30,),
                                heads('Temperature'),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: fields('$temperature °C')
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex:1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    heads('Sunset'),BoxedIcon(WeatherIcons.sunset,color: Colors.grey,)
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                  child: formatted(formattedSunsetTime, 20, formattedSunsetDate, 20, Colors.white),
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  children: <Widget>[
                                    heads('Visibility'),
                                    Icon(Icons.visibility,color: Colors.grey,),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: fields(visibilityString),
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  children: <Widget>[
                                    heads('Cloudiness'),
                                    BoxedIcon(WeatherIcons.cloudy,color: Colors.grey,),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: fields('$clouds %')
                                ),
                                SizedBox(height: 30,),
                                Row(
                                  children: <Widget>[
                                    heads('Pressure'),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                                    child: fields('$pressure hPa')
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                          )),
                      ],
                  ),
          ],
        ),
    ),
     );
  }

  Widget timeAndDay(String time, double a, String date, double b){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      formatted(time, a, date, b,Colors.white70),
       SizedBox(width: 80,),
       Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network('http://openweathermap.org/img/wn/$icon@2x.png'),
              Text('${main}',style: TextStyle(fontSize: 20.0,color: Colors.white70)),
            ],
      ),
    ],
  );
  }
  Widget formatted(String time, double a, String date, double b, Color colour){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(time, style: new TextStyle(fontSize: a,color: colour)),
      Text(date, style: new TextStyle(fontSize: b,color: colour)),
    ],
  );
  }
  Widget divider(){
   return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 20,left: 20),
      child: Divider(
        color: Colors.grey,
      ),
    );
  }
  Widget temp(String text, Color colour){
  return Padding(
    padding: const EdgeInsets.only(right: 10.0,top: 10),
    child: Text('$text',
      style: TextStyle(fontSize: 25.0, color: colour),
    ),
  );
  }
Widget heads(String text){
  return Padding(
    padding: const EdgeInsets.only(right: 10.0,top: 10),
    child: Text('$text',
      style: TextStyle(fontSize: 25.0, color: Colors.grey),
    ),
  );
}
Widget fields(String text){
  return Text('$text',
      style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
}
}

