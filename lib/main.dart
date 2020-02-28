import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:provider/provider.dart';
import 'dart:async';

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
  final String assetName = 'assets/svgs/launcherphoto.svg';
  bool alreadyLoaded = false;
  void initState(){
    super.initState();
    if(alreadyLoaded == true){
      handleTimeout();
    }
    else{
      Timer(Duration(seconds:2),()=>handleTimeout());
    }
  }

  void handleTimeout(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LuggageFollowerMain()));
  }
  var splashScreen, homeScreen, finalWidget;

  @override
  Widget build(BuildContext context) {
    alreadyLoaded = true;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 150, 0, 120),
            child: Text('Luggage Follower', style: Theme.of(context).textTheme.headline3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200.0,
                height: 200.0,
                child: SvgPicture.asset(
                  assetName,
                  semanticsLabel: 'Launcher Icon',
                  placeholderBuilder: (BuildContext context) =>
                      Container(
                          padding: const EdgeInsets.all(30.0),
                          child: const CircularProgressIndicator()
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
            child: Text('By Ijaz Mohammed', style:Theme.of(context).textTheme.bodyText1, ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:CircularProgressIndicator(
                backgroundColor: Colors.grey[900],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                value:null,
                strokeWidth: 2.0
            )
          ),

        ],
      ),
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
          primaryColor: Colors.grey[900],
          accentColor: Colors.grey,
          // Define the default font family.
          //fontFamily: 'Montserrat',
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),
            headline2: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),
            headline3: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),
            headline4: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),
            headline5: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),
            headline6: TextStyle(fontFamily: "Avenir", color: Colors.pink[500]),

          ),
        ),
        routes:{
          '/': (context) => LuggageSplashScreen(),
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






