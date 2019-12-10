import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'applicationbar.dart';
import 'navigationdrawer.dart';
import 'bluetooth.dart';


class LuggageFollowerMain extends StatefulWidget {
  @override
  _LuggageFollowerMainState createState() => _LuggageFollowerMainState();
}

class _LuggageFollowerMainState extends State<LuggageFollowerMain> {
  String _string = 'lll';


  @override
  Widget build(BuildContext context) {

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
            child: Text(_string, style: Theme.of(context).textTheme.body1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            child: LuggageFollow(),
          ),
        ],
      ),
    );
  }
}
