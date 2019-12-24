import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'about.dart';
import 'settings.dart';
import 'adddevice.dart';
import 'scheduler.dart';
import 'luggagelocation.dart';


Future main() async {
  SyncfusionLicense.registerLicense('NT8mJyc2IWhiZH1nfWN9YGpoYmF8YGJ8ampqanNiYmlmamlmanMDHmggOj42PD0hMj45OicTND4yOj99MDw+');
  runApp(LuggageFollower());
}

class LuggageSplashScreen extends StatefulWidget {
  @override
  _LuggageSplashScreenState createState() => _LuggageSplashScreenState();
}

class _LuggageSplashScreenState extends State<LuggageSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: LuggageFollower(),
      title: Text("Luggage Follower", style: Theme.of(context).textTheme.title),
      backgroundColor: Colors.pink,
      image: Image.asset('icons/icon.png'),
      gradientBackground: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),

    );
  }
}

class LuggageFollower extends StatefulWidget {
  @override
  _LuggageFollowerState createState() => _LuggageFollowerState();
}

class _LuggageFollowerState extends State<LuggageFollower> {
  @override
  Widget build(BuildContext context) {
    final appName = 'Luggage Follower';

    return ChangeNotifierProvider(
      create: (context) => Schedule(),
      child: MaterialApp(

        title: appName,
        //debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.pink,
          accentColor: Colors.pinkAccent,
          // Define the default font family.
          //fontFamily: 'Montserrat',
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            title: TextStyle(fontFamily: "Raleway", color: Colors.pink, fontSize: 30.0),
            display1: TextStyle(fontFamily: "Raleway", fontSize: 25.0),
            display2: TextStyle(fontSize: 13.0),
            display3: TextStyle(fontSize: 20.0, height: 1.4, color: Colors.white),
            body1: TextStyle(fontSize: 20.0),
            body2: TextStyle(fontSize: 15.0),

          ),
        ),
        routes:{
          '/': (context) => LuggageFollowerMain(),
          '/home': (context) => LuggageFollowerMain(),
          '/adddevice': (context) => AddDevice(),
          '/luggagelocation': (context) => LuggageLocation(),
          '/about': (context) => About(),
          '/settings': (context) => Settings(),
        },

      ),
    );
  }
}






