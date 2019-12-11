import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'applicationbar.dart';
import 'navigationdrawer.dart';
import 'bluetooth.dart';

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
  };
  initState() {
    super.initState();
    //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
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
      };
    }
    print(dataFromScreen['feet'] );

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
            child: Text('Paired', style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
            child: Divider(height: 3.0, color: Colors.pinkAccent, indent: 150, endIndent: 150),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: Text('Distance to Luggage', style: Theme.of(context).textTheme.body2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: Text('0 ' + (dataFromScreen['feet'] ? "ft" : "m"), style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: LuggageFollow(),
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
Future onSelectNotification(String payload) async {
  BuildContext context;
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