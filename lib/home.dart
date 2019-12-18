import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


import 'applicationbar.dart';
import 'navigationdrawer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class LuggageFollowerMain extends StatefulWidget {
  @override
  _LuggageFollowerMainState createState() => _LuggageFollowerMainState();
}

class _LuggageFollowerMainState extends State<LuggageFollowerMain> {
  var dataFromScreen ={
    'feet': true,
    'metres': false,
    'goingOutOfRangeAlert': false,
    'outOfRangeAlert': false,
    'device' : 'N/A'
  };

  String _luggageStatus = 'Not connected';
  String _luggageDistance = 'N/A';
  String _distanceUnits = '';
  String distance = 'N/A';

  //Bluetooth setup
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  void getDeviceInformation(bool feet) async{
    bool deviceBluetoothAvail = await bluetooth.isEnabled;
    bool deviceBluetoothEn = await bluetooth.isAvailable;

    int rssiValue =0;

    if(deviceBluetoothEn && deviceBluetoothAvail){

      changeLuggageStatus('Device not in range');

      rssiValue = getRssi();
      changeLuggageDistance(rssiValue.toString());
      changeDistanceUnits(rssiValue.toString(), feet);
    }
    else{
      //_neverSatisfied();
      changeLuggageStatus(_luggageStatus = 'Bluetooth disabled');
      changeLuggageDistance(distance);
      changeDistanceUnits(distance, feet);
    }
  }
  void changeLuggageStatus(String status){
    setState(() {
      _luggageStatus = status;
    });
    return;
  }

  void changeLuggageDistance(String distance){
    setState(() {
      _luggageDistance = distance;
    });
    return;
  }

  void changeDistanceUnits(String distance,  bool Feet){
    if (distance =='N/A'){
      _distanceUnits = '';
    }else{
      _distanceUnits =(Feet? "ft" : "m");
    }
    return;
  }



  int getRssi(){
    int rssi = 0;
    //bluetooth.getBondStateForAddress()
    return rssi;
  }

  initState() {
    super.initState();
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
  }




  @override
  Widget build(BuildContext context) {


    dataFromScreen = ModalRoute.of(context).settings.arguments;
    if(dataFromScreen == null){
      dataFromScreen ={
        'feet': true,
        'metres': false,
        'goingOutOfRangeAlert': false,
        'outOfRangeAlert': false,
        'device' : 'N/A',
      };
    }

    getDeviceInformation(dataFromScreen['feet']);
    print(dataFromScreen['device']);
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: ApplicationBar(title: 'Luggage Follower'),
      drawer: NavigationDrawer(),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: Text('Luggage Status', style: Theme.of(context).textTheme.body2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: Text(_luggageStatus, style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
            child: Divider(height: 3.0, color: Colors.pinkAccent, indent: 150, endIndent: 150),
          ),
          Container(
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(minimum: 0, maximum: 150,
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: 90,
                      width: 0.06,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Colors.pink[700],
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child:Text('90', style: Theme.of(context).textTheme.body1),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                      horizontalAlignment: GaugeAlignment.center,
                      verticalAlignment: GaugeAlignment.center,
                    )
                  ]
                )
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child:  FlatButton(
                onPressed:_showNotification,
                child: Text('Launch notif')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child:  Text('$_luggageDistance $_distanceUnits'),
          ),
        ],
      ),
    );
  }
}




Future<void> _showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Luggage Warning!', 'Oh no its going out of range!', platformChannelSpecifics,
      payload: 'item x');
}