import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'about.dart';
import 'settings.dart';



void main() => runApp(LuggageFollower());

class LuggageFollower extends StatefulWidget {
  @override
  _LuggageFollowerState createState() => _LuggageFollowerState();
}

class _LuggageFollowerState extends State<LuggageFollower> {
  @override
  Widget build(BuildContext context) {
    final appName = 'Luggage Follower';

    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        // Define the default font family.
        fontFamily: 'Montserrat',
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          title: TextStyle(fontFamily: "Raleway", color: Colors.pink, fontSize: 30.0),
          display1: TextStyle(fontFamily: "Raleway", fontSize: 25.0),
          display2: TextStyle(fontFamily: "Open Sans", fontSize: 13.0),
          body1: TextStyle(fontFamily: "Open Sans", fontSize: 20.0),
          body2: TextStyle(fontFamily: "Open Sans", fontSize: 15.0),
        ),
      ),
      routes:{
        '/': (context) => LuggageFollowerMain(),
        '/home': (context) => LuggageFollowerMain(),
        '/about': (context) => About(),
        '/settings': (context) => Settings(),
      },

    );
  }
}





