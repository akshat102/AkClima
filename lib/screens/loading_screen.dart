import 'dart:async';
import 'package:clima/screens/animated_screen.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
   var _connectionStatus = "unknown";
  Connectivity connectivity;
   dynamic weatherData;
  StreamSubscription<ConnectivityResult> subscription;
@override
  void initState() {
  super.initState();
  //getLocation(context);
  connectivity = Connectivity();
  subscription =
      connectivity.onConnectivityChanged.listen((ConnectivityResult res) {
        _connectionStatus = res.toString();
        if (res == ConnectivityResult.mobile || res == ConnectivityResult.wifi) {
          getLocation(context);
        } else {
          Timer(Duration(seconds: 3), () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 10.0,
                    title: Text("Loss Connection"),
                    content: Text("Check your Internet Connectivity !"),
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
          });
        }
      });
  }

void getLocation(BuildContext context) async {
    weatherData = await WeatherModel().getLocationWeather();
    Navigator.pushReplacement(context,
                MaterialPageRoute(
                builder:(context){
      var locationScreen = LocationScreen(locationweather: weatherData,);
      return locationScreen;
    }));

}

  @override
  Widget build(BuildContext context) {
  return Scaffold(
        body: Center(
         child:SpinKitCircle(
           size: 100,
           color: Colors.blue,
           duration: Duration(seconds: 4),
         )
        ),
    );
  }
}

