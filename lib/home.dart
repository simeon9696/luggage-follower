
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:luggagefollower/scheduler.dart';
import 'package:provider/provider.dart';
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


  String _luggageStatus = 'Tracking N/A';
  String _bluetoothStatus = 'Disabled';
  String _luggageDistance = 'N/A';
  String _distanceUnits = '';
  String address ='';


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


  String getLuggageUnits(String distance,  bool feet){
    String unit = '';
    if (distance =='N/A' || distance == null){
      unit = '';
    }else{
      unit =(feet? "ft" : "m");
    }
    return unit;
  }

  void getBluetoothStatus() async{
    bool bluetoothActive = await isBluetoothActive();
    if(bluetoothActive){
      _bluetoothStatus='Enabled';
      _luggageDistance = '0.0';
      _distanceUnits = 'ft';
    }
    else{
      _bluetoothStatus='Disabled';
      _luggageDistance = 'N/A';
      _distanceUnits = '';
    }
  }

  void setDeviceDistance(BluetoothDiscoveryResult connectedDevice, Schedule schedule){
     schedule.textDistance = connectedDevice.rssi.toString();
  }




  void _start(BuildContext context, Schedule schedule) {
    if (schedule.device != null) {
      schedule.connectionInstance.cancelDiscovery();
      schedule.connectionInstance.startDiscovery().listen((r) {

        if (r.device.address == schedule.device.device.address) {
          setDeviceDistance(r, schedule);
        }
      });
    }
  }




  initState(){
    super.initState();
    getBluetoothStatus();




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


/*    bluetooth.onStateChanged().listen((BluetoothState state)async {
      const String bluetoothOff = 'STATE_OFF';
      const String bluetoothOn = 'STATE_ON';
      String status = '';
      switch(state.stringValue){
        case bluetoothOff:{
          status = 'Disabled'|;
        }break;
        case bluetoothOn:{
          status = 'Enabled';
        }break;
      }
      setState(() {
        _bluetoothStatus = status;
      });
     print(state.stringValue);
    });*/

  }

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<Schedule>(context);
    //_dataFromScreen = ModalRoute.of(context).settings.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) => _start(context, schedule));

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
                      child: Text('Bluetooth', style: Theme.of(context).textTheme.body2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text(_bluetoothStatus, style: Theme.of(context).textTheme.body1),
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
                      child: Text('Luggage', style: Theme.of(context).textTheme.body2),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Text(schedule.luggageStat, style: Theme.of(context).textTheme.body1),
                    ),
                  ],
                ),
              ),
            ],
          ),


          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
            child: Divider(height: 3.0, color: Colors.pinkAccent, indent: 150, endIndent: 150),
          ),
          Container(
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    interval: 5,
                  pointers: <GaugePointer>[

                    MarkerPointer(
                      value: schedule.distance,
                      markerType: MarkerType.triangle,
                      offsetUnit: GaugeSizeUnit.factor,
                      markerOffset: 0.35,
                      markerWidth: 9,
                      markerHeight: 25,
                      color: Colors.pink[700],
                      borderColor: Colors.pink[700],
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      animationDuration: 1000,
                    ),
                    RangePointer(
                      value: schedule.distance,
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
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                              child:Text('Distance',style: Theme.of(context).textTheme.body1),
                            ),
                            Text(
                                '${schedule.textDistance} ${schedule.textUnits}',
                                style: Theme.of(context).textTheme.body1,
                            ),
                          ],
                        ),
                      ),
                      angle: 90,
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