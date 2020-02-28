import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:luggagefollower/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'applicationbar.dart';
import 'navigationdrawer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class LuggageFollowerMain extends StatefulWidget {
  @override
  _LuggageFollowerMainState createState() => _LuggageFollowerMainState();
}

class _LuggageFollowerMainState extends State<LuggageFollowerMain> {


  String _luggageStatus = 'Tracking N/A';
  String _bluetoothStatus = 'Disabled';
  String _luggageDistance = '...';
  String _distanceUnits = '';
  String address ='';
  double _luggageDistNumber = 25.0;
  Location location = Location();
  double _latitude = 0.0;
  double _longitude = 0.0;
  String gpsStrength = '0';
  //Bluetooth setup
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  Future<bool> isBluetoothActive()async{
    bool deviceBluetoothAvail = await bluetooth.isEnabled;
    bool deviceBluetoothEn = await bluetooth.isAvailable;
    bool bluetoothActive = false;

    if (deviceBluetoothAvail && deviceBluetoothEn){
      bluetoothActive = true;
    }else{
      bluetoothActive = false;
    }

    return Future.value(bluetoothActive);
  }


  void getBluetoothStatus() async{
    bool bluetoothActive = await isBluetoothActive();
    if(bluetoothActive){
      _bluetoothStatus='Enabled';
      _luggageDistance = '0.0';
      _distanceUnits = 'm';

    }
    else{
      _bluetoothStatus='Disabled';
      _luggageDistance = '';
      _distanceUnits = '';
      _luggageDistance = (0.0).toStringAsFixed(1);
      _luggageDistNumber = 0.0;

    }
  }

  void setDeviceDistance(BluetoothDiscoveryResult connectedDevice, Schedule schedule){
     schedule.textDistance = connectedDevice.rssi.toString();
  }


  _getLocation() async {
    var currentLocation;


    try {
      //currentLocation = await location.getLocation();

      location.onLocationChanged().asBroadcastStream().listen((LocationData currentLoc) async{
        print(currentLoc.latitude);
        print(currentLoc.longitude);
        _latitude = currentLoc.latitude;
        _longitude = currentLoc.longitude;


      });
    } on Exception {
      currentLocation = null;
    }
  }
  void calculateLuggageDistance(double lon1, double lat1, double lon2, double lat2,Schedule schedule){


    const int R = 6371 * 1000; // metres
    double phiOne = lat1 *(pi/180);
    double phiTwo = lat2*(pi/180);
    double deltaPhi = (lat2-lat1)*(pi/180);
    double deltaLambda = (lon2-lon1)*(pi/180);

    double a = (sin(deltaPhi/2) * sin(deltaPhi/2)) +
        cos(phiOne) * cos(phiTwo) *
            (sin(deltaLambda/2) * sin(deltaLambda/2));
    double c = 2 * atan2(sqrt(a), sqrt(1-a));

    double d = R * c;

    print(d);
    print(schedule.textUnits);
    if(d <= 25.0){
      if(schedule.textUnits == 'feet'){
        d = d *  3.281;
        print(d);
      }

      setState(() {

        _luggageDistance = d.toStringAsFixed(2);
        _luggageDistNumber = d;
      });

    }


    return;
  }

  String dataReady ='';
  BluetoothConnection con;
  Stream broadcastDataStream;
  StreamSubscription myStream;

  String textUnits = 'm';
  void _start(BuildContext context, Schedule schedule) async{




    con = schedule.bluetoothInstance;
    String r = "";
    List<String> split;
    broadcastDataStream= con.input.asBroadcastStream();
    myStream = broadcastDataStream.listen((gpsData) {
      if(r.indexOf('\n')>0){
        r = "";
      }
      r += ascii.decode(gpsData);
      if(r.length > 23){
        print(r);
        split = r.split(',');
      }
      calculateLuggageDistance(_longitude, _latitude, double.parse(split[0]), double.parse(split[1]),schedule);

      setState(() {
        if(int.parse(split[2]) < 0){
          gpsStrength = 'Acquring fix...';
        }
        else{
          gpsStrength = (int.parse(split[2])/16.0 *100).toStringAsFixed(1);
        }


      });
    });



    schedule.bluetoothData = broadcastDataStream;

  }


  void handleTimeout(){
    setState(() {
      _luggageDistNumber = 0.1;
      Timer(Duration(microseconds:1),()=>setState(() {_luggageDistNumber = 0.0; }));
    });
  }



  initState(){
    super.initState();
    getBluetoothStatus();

    Timer(Duration(milliseconds:3400),()=>handleTimeout());


    //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    Future onSelectNotification(String payload) async {
      showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title: Text("PayLoad"),
            content: Text("Payload : $payload"),
          );
        },
      );
    }

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@drawable/app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);


    bluetooth.onStateChanged().listen((BluetoothState state)async {
      const String bluetoothOff = 'STATE_OFF';
      const String bluetoothOn = 'STATE_ON';
      double distanceOff = 0.0;
      String status = '';
      switch(state.stringValue){
        case bluetoothOff:{
          status = 'Disabled';
          setState(() {
            _luggageDistNumber = 0.0;
            gpsStrength = '0';
            _luggageStatus = null;
            _luggageDistance = '0.0';
          });
        }break;
        case bluetoothOn:{
          status = 'Enabled';
        }break;
      }
      setState(() {
        _bluetoothStatus = status;

      });
    });

  }


  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<Schedule>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start(context, schedule));

    _getLocation();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: ApplicationBar(title: 'Luggage Follower'),
      drawer: NavigationDrawer(),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text('Bluetooth', style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text(_bluetoothStatus, style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text('Luggage', style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text((_luggageStatus == null)? 'Tracking N/A' : schedule.luggageStat, style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text('Suitcase', style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text('Opened', style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ],
                ),
              ),
            ],
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 50.0),
            child: Divider(height: 3.0, color: Colors.pinkAccent, indent: 150, endIndent: 150),
          ),
          Container(
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                    minimum: 0,
                    maximum: (schedule.textUnits == 'metres')? 25.0 : 100.0,
                    interval: (schedule.textUnits == 'metres')? 1 : 5,
                    radiusFactor: 1.08,
                  pointers: <GaugePointer>[

                    MarkerPointer(
                      value: _luggageDistNumber,
                      markerType: MarkerType.triangle,
                      offsetUnit: GaugeSizeUnit.factor,
                      markerOffset: 0.3,
                      markerWidth: 9,
                      markerHeight: 25,
                      color: Colors.pink[700],
                      borderColor: Colors.pink[700],
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      animationDuration: 1000,
                    ),
                    RangePointer(
                      value: _luggageDistNumber,
                      width: 0.06,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.pink[700],
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      animationDuration: 1000,
                      gradient: const SweepGradient(
                          colors: <Color>[Color(0xFFCC2B5E), Color(0xFF753A88)],
                          stops: <double>[0.25, 0.75],
                      ),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                           Text(
                                '$_luggageDistance',
                                style: TextStyle(fontSize: 25.0),
                           ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                '${schedule.textUnits}',
                                style: TextStyle(fontSize: 25.0),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.settings_input_antenna),
                                Text(
                                    '  $gpsStrength%',
                                  style: TextStyle(fontSize: 15.0),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                      horizontalAlignment: GaugeAlignment.center,
                      verticalAlignment: GaugeAlignment.center,
                      angle: 90,
                    )
                  ]

                ),
              ]
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child:  FlatButton(
                onPressed:_showNotification,
                child: Text('Launch notification')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}




Future<void> _showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker', color: Colors.pink[500]);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Luggage Warning!', 'Oh no its going out of range!', platformChannelSpecifics,
      payload: 'Test');
}

class SalesData{
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}