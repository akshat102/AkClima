import 'package:flutter/material.dart';

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan',
  fontSize: 30.0,
  color: Colors.white
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kTextFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(Icons.location_city, size: 40,color: Colors.white),
    hintText: 'Enter City Name',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide.none,
    )
);

const bgColor = Color(0xff00001a);
const openweatherMapURL = 'http://api.openweathermap.org/data/2.5/weather';
